#INCLUDE "Protheus.ch"
#INCLUDE "RWMAKE.ch"
#INCLUDE "TopConn.ch"
#INCLUDE "TBICONN.CH"

#DEFINE EOL			Chr(13)+Chr(10)  

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � CP01004  �Autor  � Augusto Ribeiro	 � Data �  18/04/2011 ���
�������������������������������������������������������������������������͹��
���Desc.     � Rotina de processamento via schedule                       ���
���          �                                                            ���
���Parametros� cTipo = "DIR" ou "FTP" - Origem dos Arquivos XML           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
User Function CP01004(cTipo)
Local cMsgErro		:= ""
Local cExtArq		:= "*.xml"
Local lAuto			:= ISBLIND()
Local aArqTemp, nArqTemp, nI
Local cFTPURL		:= ALLTRIM(U_CP01005G("11", "XMLFTP"))
Local nFTPPort		:= U_CP01005G("11", "XMLFPOR")
Local cFTPUser		:= ALLTRIM(U_CP01005G("11", "XMLFUSR"))
Local cFTPPass 		:= ALLTRIM(U_CP01005G("11", "XMLFPSW"))
Local cFTPDir		:= ALLTRIM(U_CP01005G("11", "XMLFDIR"))
Local aRetAux, aRetPre   
Local _cCodEmp, _cCodFil       
Local lGeraPreNF	:= U_CP01005G("11", "XMLGPNF")	//| Gera Pre-Nota apos importadar Danfe

Local aAreaZ10, aAreaZ11
Local cCFBYPASS		:= ALLTRIM(U_CP01005G("11", "CFPRENOTA"))
Local aCFBYPASS

Default cTipo 		:= "DIR"

PRIVATE cPathTemp		:= LOWER(ALLTRIM(U_CP01005G("10", "XMLTEMP"))) //| Path dos arquivos XML Temporarios

	Conout("###| CP01004 - INICIO "+cTipo+"|###")

                       
	IF cTipo == "FTP"
	
		IF FTPCONNECT( cFTPURL, nFTPPort, cFTPUser, cFTPPass )
			
			IF !EMPTY(cFTPDir)
				IF !(FTPDirChange(cFTPDir))
		
					cMsgErro	:= "Falha ao posicionar na Pasta do FTP: "+cFTPDir    
				ENDIF
			ENDIF
		         
			IF EMPTY(cMsgErro)	
				aDirFTP	:= FTPDirectory(cExtArq)	
	//			SLEEP(1000)	//| 1 Segundo
				       
				IF !EMPTY(aDirFTP)
					Processa({|| FTP2TEMP(aDirFTP)}, "Verificando Arquivos")
				ENDIF
			ENDIF				                
			
			FTPDisconnect()		
		ELSE
			cMsgErro	:= " N�o foi poss�vel conectar ao servidor FTP: "+cFTPURL
		ENDIF 
		
	ELSEIF cTipo <> "DIR"
		cMsgErro	:= "Tipo Origem arquivo desconhecido: "+cTipo
	ENDIF   
	                                                                         
	
	IF EMPTY(cMsgErro)

		//������������������������������������Ŀ
		//� Inicia Importacao dos arquivos XML �
		//��������������������������������������
		aArqTemp	:= Directory(cPathTemp+"*.xml")
		nArqTemp	:= LEN(aArqTemp)
		    
		ProcRegua(nArqTemp)
		FOR nI := 1 TO nArqTemp
			IncProc("Importando "+TRANSFORM(nI, "@E 999,999")+" DE "+TRANSFORM(nArqTemp, "@E 999,999"))
			
			aRetAux	:= U_CP01001A( cPathTemp+lower(alltrim(aArqTemp[nI,1])) , .F., .T.)	
			
			//���������������������������������
			//� Gera Pre-nota Automaticamente �
			//���������������������������������
//			IF aRetAux[1]
//				aRetAux	:= U_CP01001C(.T.)
//			ENDIF          
			

			//���������������Ŀ
			//� Gera Pre-Nota �
			//�����������������
//			IF lGeraPreNF .AND. aRetAux[1] .AND. !EMPTY(aRetAux[4])   


			
			aAreaZ10	:= Z10->(GetArea())
			aAreaZ11	:= Z11->(GetArea())
			
			DBSELECTAREA("Z10")
			Z10->(DBSETORDER(1))
			
			DBSELECTAREA("Z11")
			Z11->(DBSETORDER(1)) 
			
			/*----------------------------------------
				29/05/2019 - Jonatas Oliveira - Compila
				Verifica se CFOP da nota permite gerar 
				Pre-nota Automaticamente
			------------------------------------------*/
			If !EMPTY(cCFBYPASS) 
				aCFBYPASS := U_cpC2A(cCFBYPASS, "/")
			EndIf 
			
			IF Z10->(DBSEEK(XFILIAL("Z10")+aRetAux[1][4]+Z10->Z10_TIPARQ,.F.))
				Z11->(DBGOTOP())
				
				IF Z11->(DBSEEK(Z10->( Z10_FILIAL + Z10_CHVNFE ))) 
					IF ASCAN(aCFBYPASS, RIGHT(ALLTRIM(Z11->Z11_CFOP),3) ) > 0 
						lGeraPreNF := .T.
					ENDIF 
				ENDIF 
			ENDIF
			 
			RestArea(aAreaZ10)
			RestArea(aAreaZ11)	
						
			
			IF lGeraPreNF .AND. aRetAux[1][2] .AND. !EMPTY(aRetAux[1][4])			
				
				DBSELECTAREA("Z10")
				Z10->(DBSETORDER(1))
				IF Z10->(DBSEEK(XFILIAL("Z10")+aRetAux[1][4]+Z10->Z10_TIPARQ,.F.)) .AND. Z11->(DBSEEK(XFILIAL("Z11")+aRetAux[1][4]+Z10->Z10_TIPARQ,.F.)) 
					IF !EMPTY(Z10->Z10_CODEMP) .AND. !EMPTY(Z10->Z10_CODFIL)
					                              
						aAreaZ10	:= Z10->(GetArea())
						aAreaZ11	:= Z11->(GetArea())
					
					
						cWFEmp	:= Z10->Z10_CODEMP
						cWFFil	:= Z10->Z10_CODFIL					
						//��������������������������������������������Ŀ
						//� Posiciona na Filial de retorno do Workflow �
						//����������������������������������������������
						_cCodEmp 	:= SM0->M0_CODIGO
						_cCodFil	:= SM0->M0_CODFIL
						                                     
						
						IF _cCodEmp+_cCodFil <> cWFEmp+cWFFil
							CFILANT := cWFFil
							opensm0(cWFEmp+CFILANT)
						ENDIF
						                  

						//������������������������������Ŀ
						//� Reposiciona Cabecalho e Item �
						//��������������������������������
						RestArea(aAreaZ10)
						RestArea(aAreaZ11)
						
						
						//���������������Ŀ
						//� Gera Pre-Nota �
						//�����������������  
						aRetPre	:= U_CP0102E(.T., Z10->Z10_CHVNFE,Z10->Z10_TIPARQ)
						
						    
						//������������������Ŀ
						//� Envia WF com LOG �
						//��������������������
						IF !(aRetPre[1]) .AND. !EMPTY(aRetPre[2])
//							U_CP01001W(aRetAux[4]+Z10->Z10_TIPARQ, aRetPre[2])
						ENDIF     
						 
						
						//�����������������Ŀ
						//� Restaura Filial �
						//�������������������
						IF _cCodEmp+_cCodFil <> cWFEmp+cWFFil
							CFILANT := _cCodFil
							opensm0(_cCodEmp+CFILANT)			 			
						ENDIF 
						
						
						//������������������������������Ŀ
						//� Reposiciona Cabecalho e Item �
						//��������������������������������
						RestArea(aAreaZ10)
						RestArea(aAreaZ11)						
					ELSE
						Conout("###| CP01004 - CodEmp, CodFil em branco - "+aRetAux[1][4]+" |###")										
					ENDIF     
				ELSE
					Conout("###| CP01004 - Chave nao encontrada na Z10 e Z11 - "+aRetAux[1][4]+" |###")					
				ENDIF
			ELSE     
				Conout("###| CP01004 - Falha ao registrar XML |###")
			ENDIF
			
			lGeraPreNF	:= U_CP01005G("11", "XMLGPNF")
			
		Next nI
	ELSE
		IF lAuto
			MSGBOX("Falha: "+cMsgErro, "Verificando arquivos XML","ALERT")		
		ENDIF   
		
		Conout("###| Falha: "+cMsgErro)	
	ENDIF

                                        
	Conout("###| CP01004 - FIM    |###")
Return()

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � CP0104FTP�Autor  � Augusto Ribeiro	 � Data �  18/04/2011 ���
�������������������������������������������������������������������������͹��
���Desc.     � Rotina Automatica de processamento de XML via FTP          ���
���          �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/  
User Function CP0104FTP(aParam) 

Default aParam := {"01","01"} //| ##### REMOVER

IF LEN(aParam) == 2
	
	RpcSetType(3)
	RpcSetEnv( aParam[1], aParam[2],,,'COM')
	 
		U_CP01004("FTP")
	
	RpcClearEnv()
ENDIF

Return
               


/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � CP01004A �Autor  � Augusto Ribeiro	 � Data �  18/04/2011 ���
�������������������������������������������������������������������������͹��
���Desc.     � Rotina Automatica de processamento de XML via DIR          ���
���          �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/  
User Function CP0104DIR(aParam) 

Default aParam := {"01","01"} //| ##### REMOVER

IF LEN(aParam) == 2
	
	RpcSetType(3)
	RpcSetEnv( aParam[1], aParam[2],,,'COM')
	 
		U_CP01004("DIR")
	
	RpcClearEnv()	
ENDIF

Return


/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � FTP2TEMP �Autor  � Augusto Ribeiro	 � Data �  18/04/2011 ���
�������������������������������������������������������������������������͹��
���Desc.     � Verifica arquivos a serem importados do FTP                ���
���          �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
Static Function FTP2TEMP(aDirFTP) 
Local aDirFTP         
Local lImpXML	:= .T.
Local nDirFTP	:= 0  
Local cFtpDest	:= ""   
Local aArqTemp	:= {}

Default aDirFTP := {}  

//����������������������������������������������Ŀ
//� Verifica arquivos que j� est�o na pasta Temp �
//������������������������������������������������
aArqTemp	:= Directory(cPathTemp+"*.xml")

       
nDirFTP	:= LEN(aDirFTP)
ProcRegua(nDirFTP)
        
IF nDirFTP > 0    
	
	DBSELECTAREA("Z10")
	Z10->(DBSETORDER(1))
	
	For nI := 1 to nDirFTP
		IncProc("Processando")
		
		cNomeArq	:= LOWER(ALLTRIM(aDirFTP[nI,1]))

		Z10->(DBSETORDER(4))	//| Z10_FILIAL, Z10_ARQUIV
		
		//���������������������������������������������Ŀ
		//� Verifica se o arquivo j� esta na pasta temp �
		//�����������������������������������������������
		IF ASCAN(aArqTemp, {|x| lower(alltrim(x[1])) == cNomeArq }) > 0
			lImpXML	:= .F.
			
		//����������������������������������������Ŀ
		//� Verifica se o Arquivo j� foi importado �
		//������������������������������������������		
		ELSEIF Z10->(DBSEEK(XFILIAL("Z10")+cNomeArq,.F.)) 
			lImpXML	:= .F.
		ELSE     
			//�����������������������������������������������������������������Ŀ
			//� Verifica se o Arquivo j� foi importado como XML de Cancelamento �
			//�������������������������������������������������������������������
			Z10->(DBSETORDER(5))	//| Z10_FILIAL, Z10_ARQCAN
			IF Z10->(DBSEEK(XFILIAL("Z10")+cNomeArq,.F.))
				lImpXML	:= .F.
			ENDIF
		ENDIF     
		                      	
		IF lImpXML                                            
	
//			FTPCONNECT( cFTPURL, nFTPPort, cFTPUser, cFTPPass )
		
			IF FTPDownLoad( cPathTemp+cNomeArq, cNomeArq )

				//���������������������������������������������Ŀ
				//� Mover arquivo para Pasta Processados do FTP �
				//�����������������������������������������������      
				cFtpDest	:= "/processados/"+cNomeArq
				IF !FtpRenameFile( cNomeArq, cFtpDest )
					CONOUT("###| Falha ao Mover arquivo "+cFtpDest)
				ENDIF
					
			
				CONOUT("###| Copiado com Sucesso: "+cNomeArq)
			ELSE
				CONOUT("###| Falha no Download do arquivo: "+cNomeArq)
			ENDIF  
			
			
		//����������������������Ŀ
		//�Arquivo Ja processado �
		//������������������������
		ELSE                      
			

			
			//���������������������������������������������Ŀ
			//� Mover arquivo para Pasta Processados do FTP �
			//�����������������������������������������������      
			cFtpDest	:= "/processados/"+cNomeArq
			CONOUT("###| Arquivo Ja processado "+cFtpDest)					
			IF !FtpRenameFile( cNomeArq, cFtpDest )
				CONOUT("###| Falha ao Mover arquivo "+cFtpDest)
			ENDIF		
		ENDIF		
	Next nI
ENDIF

Return()
