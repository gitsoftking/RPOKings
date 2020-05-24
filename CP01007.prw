#Include "Protheus.Ch"
#Include "Rwmake.Ch"
#INCLUDE 'TBICONN.CH'
#INCLUDE "fileio.ch"


/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � CP01007  �Autor  �Augusto Ribeiro     � Data � 11/02/2011  ���
�������������������������������������������������������������������������͹��
���Desc.     � Realiza o download de e-mails via POP e separa arquivos    ���
���          �XML                                                         ���
�������������������������������������������������������������������������͹��
���Uso       �      	                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
User Function CP01007()
Local aArea			:= GetArea()                           

Local cPathXML		:= ALLTRIM(U_CP01005G("10", "XMLTEMP"))
Local cPathPDF		:= ALLTRIM(U_CP01005G("10", "XMLPDF"))

Local cPathAjuste	:= ALLTRIM(U_CP01005G("11", "PATHAJUST"))
Local cServer   	:= ALLTRIM(U_CP01005G("11", "MAILSRVPOP"))		//SERVIDOR POP
Local cAccount  	:= ALLTRIM(U_CP01005G("11", "MAILLOGIN"))		//CONTA DE EMAIL 
Local cPassword 	:= ALLTRIM(U_CP01005G("11", "MAILSENHA"))		//SENHA DA CONTA

Local aInfAnexo
Local oServer, oMessage, nErro  
Local nI, nY    
Local cPrefIni, cPrefFim 
Local nTotMail	:= 0
Local nTotAnexo	:= 0

Conout("*** CP01007 | INICIO "+DTOC(dDataBase)+" "+time())
                                 

	
                                       
Conout("*** CP01007 | Conta de email: "+cAccount)		
                                  

//���������������������������������
//� Cria Conexao com servidor pop �
//���������������������������������
oServer := TMailManager():New()
oServer:Init( cServer, "", cAccount, cPassword, 0, 110 )
                         
oServer:SetPopTimeOut( 60 )

oMessage := TMailMessage():New()		
                         
//��������������Ŀ
//� Abre Conexao �
//����������������      
nErro	:= oServer:PopConnect()
If nErro == 0    
                          

	//����������������������������������������������
	//� Verifica quantidade de e0mails no servidor �
	//����������������������������������������������
	oServer:GetNumMsgs(@nTotMail)                
	IF nTotMail > 0
		                 
		ProcRegua(nTotMail)
		
		FOR nI := 1 to nTotMail
			nTotAnexo	:= 0
			lAnexoTxt	:= .F.
			lBaixou		:= .F.
			lDelete		:= .F.
			
			IncProc("Verificando e-mails...")
			
			//Limpa o objeto da mensagem
			oMessage:Clear()
			//Recebe a mensagem do servidor
			oMessage:Receive( oServer, nI )		 
			
			//Recebe a mensagem do servidor
			nTotAnexo := oMessage:GetAttachCount() 
			                                     
			
			FOR nY := 1 TO nTotAnexo                  
			
				aInfAnexo	:= oMessage:GetAttachInfo(nY)	
				cNomeArq	:= lower(alltrim(aInfAnexo[1]))
				
				IF EMPTY(cNomeArq)
					cNomeArq	:= lower(alltrim(aInfAnexo[4]))
				ENDIF
				
				IF !EMPTY(cNomeArq)

					cExtArq	:= ""
					IF RIGHT(cNomeArq,3) == "xml"
						cExtArq		:= "xml"		
						cPathArq	:= cPathXML
					ELSEIF RIGHT(cNomeArq,3) == "pdf"  
						cExtArq		:= "pdf"
						cPathArq	:= cPathPDF
					ENDIF
                                                
                            
					IF !EMPTY(cExtArq)  
					
						Conout("*** CP01007 | Arquivo identificado:"+cNomeArq)
						lAnexoTxt := .T.
						
						cNomeArq	:= DTOS(DDATABASE)+"_"+STRTRAN(TIME(),":","")+"_"+ALLTRIM(LEFT(cNomeArq,150))
						cNomeArq	:= lower(cNomeArq)
                                                             
						//�����������������������������������������������������Ŀ
						//� D_AJUSTE_PATH e necessario pois a funcao SaveAttach �
						//� esta considerando como Root Path a pasta AppServer  �
						//�������������������������������������������������������    
						cAux	:= cPathAjuste+cPathArq+cNomeArq
						IF oMessage:SaveAttach(nY,cAux)						
						     //| Confirma se o arquivo foi salvo
							IF FILE(cPathArq+cNomeArq)
								lBaixou	:= .T.
								lDelete	:= .T.
							ENDIF 
						ELSE
							Conout("*** CP01007 | Falha ao Savar o Anexo: "+cAux)  
						ENDIF
					ELSE
						Conout("*** CP01007 | Arquivo nao possui extensao txt:"+cNomeArq)
					ENDIF
				ELSE
					Conout("*** CP01007 | Nome do arquivo em branco")
				ENDIF
			NEXT nY
			

			//�������������������������������
			//� Exclui mensagem do Servidor �
			//�������������������������������
			IF lDelete //IF(lAnexoTxt, lBaixou, .T.)
			   	oServer:DeleteMsg( nI )			        
   					Conout("*** CP01007 | E-mail Excluido - lAnexoTxt: "+iif(lAnexoTxt, "TRUE", "FALSE")+ " - lBaixou "+IIF(lBaixou, "TRUE", "FALSE"))	
			ENDIF	
		NEXT nI
	ELSE   
		Conout("*** CP01007 | Caixa de e-mail vazia")	
	ENDIF		
	                                
	oMessage:Clear()
	//Desconecta do servidor POP
	oServer:POPDisconnect()			
ELSE   
	Conout("*** CP01007 | ERRO: "+oServer:GetErrorString(nErro))		
	Conout("*** CP01007 | Falha na conexao: "+cServer)
	Alert(oServer:GetErrorString(nErro))
ENDIF
                         
 
Conout("*** CP01007 | FIM "+DTOC(dDataBase)+" "+time())

RestArea(aArea)
Return
                       
