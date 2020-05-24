#INCLUDE "Protheus.ch"
#INCLUDE "RWMAKE.ch"
#INCLUDE "TopConn.ch"
#INCLUDE "TBICONN.CH"

#DEFINE EOL			Chr(13)+Chr(10)  

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � CP01003  �Autor  � Augusto Ribeiro	 � Data �  19/03/2011 ���
�������������������������������������������������������������������������͹��
���Desc.     � Tabela de conversao de unidades de medidas                 ���
���          �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
User Function CP01003()
Private cCadastro 	:= OemToAnsi("Convers�o de Unidade de Medida")
Private aRotina
 
aRotina		:= { { 'Pesquisar' 		,'AxPesqui' 					,0,1} ,;
				{ "Visualizar"		,"AxVisual"  					,0,2} ,;
				{ "Incluir"			,"AxInclui('Z09',,3,,,,'U_CP01003V()')"	,0,3},;        	          
				{ "Alterar"			,"AxAltera('Z09',,4,,,,,'U_CP01003V()')",0,4},;				
				{ "Excluir"			,"AxDeleta"  					,0,5} ,;
				{ "Testar"			,"U_CP01003T"					,0,2} }        
				
  				                	                                    
DBSELECTAREA("Z09")
Z09->(DBSETORDER(1))
//MBrowse(nT,nL,nB,nR,cAlias,aFixe,cCpo,nPosI,cFun,nDefault, aColors,cTopFun,cBotFun, nFreeze,bParBloco, lNoTopFilter, lSeeAll,lChgAll, cExprFilTop )					
mBrowse( 6, 1,22,75,"Z09",,,2)

Return



/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � CP01003A �Autor  � Augusto Ribeiro	 � Data �  19/03/2011 ���
�������������������������������������������������������������������������͹��
���Desc.     � Converte valor entre unidade de medidas informadas         ���
���          �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
User Function CP01003A(cUMDe, cUMPara, nQtde, nValor)
Local xRet	:= {0,0}

Default nValor	:= 0
                     
IF !EMPTY(cUMDe) .AND. !EMPTY(cUMPara) 
	
	cUMDe	:= PADR(cUMDe, TAMSX3("Z09_UMDE")[1])

	IF cUMDe == cUMPara
		xRet	:= nQtde
		IF nValor > 0
			xRet	:= {xRet, nValor}
		ENDIF
	ELSE                           
	
		IF nValor > 0
			xRet	:= {0, 0}
		ENDIF

		DBSELECTAREA("Z09")
		Z09->(DBSETORDER(1))
		
		IF Z09->(DBSEEK(XFILIAL("Z09")+cUMDe+cUMPara,.F.))
		
			IF Z09->Z09_TIPCON == "M"
				xRet	:= 	nQtde * Z09->Z09_FATOR
				IF nValor > 0
					xRet	:= {xRet, nValor / Z09->Z09_FATOR}
				ENDIF	     				
			ELSEIF Z09->Z09_TIPCON == "D"
				xRet	:= 	nQtde / Z09->Z09_FATOR	     
				IF nValor > 0
					xRet	:= {xRet, nValor * Z09->Z09_FATOR}
				ENDIF
			ENDIF         
		ELSE              
			//������������������������������������������������Ŀ
			//� Caso nao seja encontrado o fator de conversao, �
			//� Realiza busca reversa                          �
			//��������������������������������������������������
			cUMDe	:= PADR(cUMDe, TAMSX3("Z09_UMPARA")[1])
			cUMPara	:= PADR(cUMPara, TAMSX3("Z09_UMDE")[1])			
			
			Z09->(DBSETORDER(2))                          
			IF Z09->(DBSEEK(XFILIAL("Z09")+cUMDe+cUMPara,.F.))		
			
				IF Z09->Z09_TIPCON == "M"
					xRet	:= 	nQtde / Z09->Z09_FATOR	     			     
					IF nValor > 0
						xRet	:= {xRet, nValor * Z09->Z09_FATOR}
					ENDIF					
					
				ELSEIF Z09->Z09_TIPCON == "D"
					xRet	:= 	nQtde * Z09->Z09_FATOR	     			
					
					IF nValor > 0
						xRet	:= {xRet, nValor / Z09->Z09_FATOR}
					ENDIF					
				ENDIF		
			ENDIF		
		ENDIF
	ENDIF	
ENDIF
	
Return(xRet)

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � CP01003V �Autor  � Augusto Ribeiro	 � Data �  19/03/2011 ���
�������������������������������������������������������������������������͹��
���Desc.     � Validacao n a gravao dos restistros                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
User Function CP01003V()
Local lRet		:= .T.   
Local aAreaZ09	:= Z09->(GetArea())
Local nRecno	:= Z09->(Recno())
        
IF !EMPTY(M->Z09_UMDE) .AND. !EMPTY(M->Z09_UMPARA)

	IF M->Z09_UMDE == M->Z09_UMPARA	
		MSGBOX("A unidade de medida deve ser diferente a unidade correspondente.", "UM Inv�lida", "alert")
		lRet	:= .F.
	ELSE
		DBSELECTAREA("Z09")
		Z09->(DBSETORDER(1))
		
		IF Z09->(DBSEEK(XFILIAL("Z09")+M->Z09_UMDE+M->Z09_UMPARA,.F.))
			IF INCLUI .OR. ( ALTERA .AND. nRecno <> Z09->(Recno()) )
				MSGBOX("Relacionamento j� cadastrado", "J� Cadastrado", "alert")		 
				lRet	:= .F.			
			ENDIF
		ELSE              
			//������������������������������������������������Ŀ
			//� Caso nao seja encontrado o fator de conversao, �
			//� Realiza busca reversa                          �
			//��������������������������������������������������
			Z09->(DBSETORDER(2))
			IF Z09->(DBSEEK(XFILIAL("Z09")+M->Z09_UMDE+M->Z09_UMPARA,.F.))
				MSGBOX("Relacionamento j� cadastrado"+EOL+"De "+M->Z09_UMPARA+" Para "+M->Z09_UMDE, "J� Cadastrado", "alert")		 			
				lRet	:= .F.				
			ENDIF
		ENDIF	
	ENDIF
	
ENDIF
RestArea(aAreaZ09)

Return(lRet)



/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � CP01003T �Autor  � Augusto Ribeiro	 � Data �  19/03/2011 ���
�������������������������������������������������������������������������͹��
���Desc.     � Realiza teste da conversao da unidade de mediada cadastrada���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
User Function CP01003T()
Local cMsgTeste	:= "" 
Local nConvert	:= U_CP01003A(Z09->Z09_UMDE, Z09->Z09_UMPARA, 1)
Local cDescDe, cDescPara
                        
	cMsgTeste	:= "1 "+Z09->Z09_UMDE+" corresponde a "+alltrim(TRANSFORM(nConvert, "@E 999,999.9999")+" "+Z09->Z09_UMPARA)
        
	MSGBOX(cMsgTeste, "Teste | "+Z09->Z09_UMDE+" -> "+Z09->Z09_UMPARA, "INFO")

Return()