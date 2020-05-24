#include 'protheus.ch'
#include 'parmtype.ch'


/*/{Protheus.doc} CP0101FT
Gravações complementares na importação do XML
@author Jonatas Oliveira | www.compila.com.br
@since 07/06/2019
@version 1.0
/*/
User Function CP0101FT(nRecZ10, _oXML, _cTomaTip )
	Local _oDANFE
	Local _oIdent
	Local _cTomaTip
	Local _oDestRem, _oDestCte, _oEmitente
	Local cCnpjAux	:= ""	
	Local aRetEmp	:= {"", ""}
	Local lRespFrt	:= .F.
	Local lCteRem 	:= U_CP01005G("11", "CTEREMET")
	
	/*----------------------------------------
		07/06/2019 - Jonatas Oliveira - Compila
		Quando estiver como remetente e não estiver 
		em nenhum outro lugar dentro do CTE altera 
		o Status para impedir a geração de nota
	------------------------------------------*/
	IF lTpCte
		IF !lCteRem
			IF Z10->Z10_TIPARQ == "C" 
				IF VALTYPE(XmlChildEx(_oXML, "_CTEPROC")) == "O"
					IF VALTYPE(XmlChildEx(_oXML:_cteproc, "_CTE")) == "O"
	
						_oDANFE		:= _oXML:_cteproc:_CTe 
	
						_oEmitente	:= _oDANFE:_InfCTe:_Emit
						_oDestCte	:= _oDANFE:_InfCTe:_DEST
						_oDestRem	:= _oDANFE:_InfCTe:_REM
						/*
						0- Remetente;
						1- Expedidor;
						2 - Recebedor;
						3 - Destinatário. 
						*/
						
						IF _cTomaTip == "0" //|Remetente|
						
							IF VALTYPE(XmlChildEx(_oDestRem, "_CNPJ")) == "O"
								cCnpjAux	:= _oDestRem:_CNPJ:TEXT
							ELSEIF VALTYPE(XmlChildEx(_oDestRem, "_CPF")) == "O"
								cCnpjAux	:= 	_oDestRem:_CPF:TEXT
							ENDIF
							
							aRetEmp 	:= fEmpFil(cCnpjAux)
							
							IF EMPTY(aRetEmp[1])
								lRespFrt := .F.
							ELSE
								lRespFrt := .T.
							ENDIF 
							
						ELSEIF 	_cTomaTip == "3" //|Destinatário|
						
							IF VALTYPE(XmlChildEx(_oDestCte, "_CNPJ")) == "O"
								cCnpjAux	:= _oDestCte:_CNPJ:TEXT
							ELSEIF VALTYPE(XmlChildEx(_oDestCte, "_CPF")) == "O"
								cCnpjAux	:= 	_oDestCte:_CPF:TEXT
							ENDIF
							
							aRetEmp 	:= fEmpFil(cCnpjAux)
							
							IF EMPTY(aRetEmp[1])
								lRespFrt := .F.
							ELSE
								lRespFrt := .T.
							ENDIF 						
							
						ENDIF 
	
	//					IF !EMPTY(aRetEmp[1])	
	//						cCnpjAux 	:= _oDestCte:_CNPJ:TEXT
	//						aRetEmp 	:= fEmpFil(cCnpjAux)
	//
	//						IF EMPTY(aRetEmp[1])
	//							cCnpjAux 	:= _oEmitente:_CNPJ:TEXT
	//							aRetEmp 	:= fEmpFil(cCnpjAux)
	//
	//							IF EMPTY(aRetEmp[1])
	//								lRespFrt	:= .T.
	//							ENDIF 
	//						ENDIF
	//					ENDIF 								 
					ENDIF
				ENDIF
			ENDIF
			
			//|Caso não seja responsavel pelo frete altera status|
			IF !lRespFrt
				Z10->(RecLock("Z10",.F.))
				Z10->Z10_STATUS := "6"
				Z10->(MsUnLock())
			ENDIF
		ENDIF
	ENDIF
Return()



/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ fEmpFil  ºAutor  ³Augusto Ribeiro     º Data ³ 04/12/2010  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Retorno Empresa Filial do SM0 do CNPJ passado              º±±
±±º          ³                                                            º±±
±±ºParametros³ cCNPJ                                                      º±±
±±ºRetorno   ³ aRet := {cCodEmp, cCodFild}                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/  
Static Function fEmpFil(cCNPJ)
	Local aRet		:= {"", ""}   
	Local aRetAux	:= {}
	Local aAreaSM0 
	Local cEmpParam	:= ALLTRIM(U_CP01005G("11", "XMLEFIL"))

	IF !EMPTY(cCNPJ)           
		cCNPJ	:= ALLTRIM(cCNPJ)

		DBSELECTAREA("SM0")
		aAreaSM0 := SM0->(GetArea())

		IF ALLTRIM(SM0->M0_CGC) == cCNPJ
			aRet := {SM0->M0_CODIGO, SM0->M0_CODFIL}
		ELSE
			SM0->(DBGOTOP())  

			WHILE SM0->(!EOF())        

				IF ALLTRIM(SM0->M0_CGC) == cCNPJ  
					IF EMPTY(aRetAux)
						aRetAux := {SM0->M0_CODIGO, SM0->M0_CODFIL}	
					ENDIF
				ENDIF		    

				SM0->(DBSKIP())
			ENDDO
		ENDIF   


		IF !EMPTY(aRetAux)
			aRet	:= aRetAux
		ENDIF

		RestArea(aAreaSM0)
	ENDIF

Return(aRet)      