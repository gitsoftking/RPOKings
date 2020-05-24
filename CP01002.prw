#INCLUDE "Protheus.ch"
#INCLUDE "RWMAKE.ch"
#INCLUDE "TopConn.ch"
#INCLUDE "TBICONN.CH"

#DEFINE EOL			Chr(13)+Chr(10)  
      
Static nA5PRODUTO, nA5NOMPROD, nA5CODPRF, nB1DESC, nA5FABR, nA5LJFB

/*¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨MANUTENCOES REALIZADAS¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨|
|																												 |		
|DIA 10/03/2014 - Jonatas Oliveira																			 |
|	- Adicionado parametro para inclusao automatica de produto entrada e saida                 	 |
|	- Criado Ponto de entrada para opções do menu                                        			 |
|																												 |
|																												 |
|																												 |
|																												 |
¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨*/

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ CP0102E  ºAutor  ³ Augusto Ribeiro	 º Data ³  04/12/2010 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Importa XML da Danfe para a Pre-Nota	                      º±±
±±º          ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function CP0102E(lAuto,cChvDanfe,cTpEntr)
Local aRet			:= {.F.,"",0}
Local aAreaSF1		:= SF1->(GetArea())
Local cAtencao		:= ""
        
Local cPathDest		:= LOWER(ALLTRIM(U_CP01005G("11", "XMLOK"))) //| Path de destino dos arquivos
Local cTipoNFE		:= ALLTRIM(U_CP01005G("11", "XMLTPNF")) //| 
Local cTipoCTE		:= ALLTRIM(U_CP01005G("11", "XMLTPCTE")) //| 
Local lCadFor		:= U_CP01005G("11", "CADFOR")
Local lCadProFor	:= U_CP01005G("11", "CADPXF")
Local lPcProdFor	:= U_CP01005G("11", "PEDPXF")//|Cadastro de Produto X Fornecedor com base no Ped. Compra
Local lControL		:= U_CP01005G("11", "LOTECONTR") 	//| Permite avançar sem lote quando o produto(B1_RASTRO) estiver configurado? .T. ou .F.

Local lProdCli		:= U_CP01005G("11", "PRODCLIFOR")//|Cadastro de Produto com base no XML
Local lDocEnt		:= U_CP01005G("11", "NOTASPRE")//|Gera Nota sem passar pela Pré-nota?
Local lTesProd		:= U_CP01005G("11", "TESPROD")//|Atribui TES vinculada ao Produto?

Local cFullPath		:= cPathDest 

Local aCabecNFe, aLinhaNfe, aItensNFe,aItensNcm,aPosIpi
Local nY, nI, nItem, lAbort
Local cErroExec, cPathLog   
Local cSerie, cNumNFe6
Local aGeraNota
Local aProdFor		:= {}   
Local aItemOr		:= {}   
Local lAuto
Local cPriUM, cSegUM, nQtde, nAux, cCFOP 
Local nQtdePri, nQtdeSeg, nVlrUni, nVlrTot  
Local nD1COD, nD1QUANT, nD1TOTAL,nD1LOT, nD1DTL
Local nPosAgp, lSF1OK, cLogSF1  
Local aAreaZ10, aAreaZ11
Local nPosPro :=  0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Numero de casas decimais ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local nDQUANT	:= TAMSX3("D1_QUANT")[2]
Local nDVUNIT	:= TAMSX3("D1_VUNIT")[2]
Local nDTOTAL	:= TAMSX3("D1_TOTAL")[2]
Local nDifUM	:= 0   
Local cInfAdic	:= ""
Local cQuery	:= "" 
Local aItemAgp	:= {}
Local aConvUM	:= {}
Local lExistSF1	:= .F.   
Local nImp		:= 0	
Local oImposto 
Local aRetFor	:= {}
Local lExistFor	:= .F.
Local cEmpParam	:= ALLTRIM(U_CP01005G("11", "XMLEFIL"))
Local aDadosPed := {}             
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis para controle do uso de Fornecedor ou Cliente ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local cCliFor	:= "", cLoja := "", cUFCliFor := ""
Local lUtilCli	:= .F.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas no objeto XML ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local oXML, oDANFE, oEmitente, oIdent, oDestino, oTotal, oTransp, oDet

Local lVincOrig		:= .F.//U_CP01005G("11", "VINCORIG")
Local cTES		:= ""
Local nPosTes	:= 0 
Local aCabec	:= {}
Local cCFOPEXP
Local aCFOPEXP	:= {}
Local lCFOPEXP 	:= .F. 

Local aRetAux	:= {}
Local nItensNF	:= 0
Local nNFxPC	:= 0

Local nOpc 		:= 3
Local oModel 	:= Nil
Local aChvRef	:= {}

Private cAviso	:= ""
Private cErro	:= ""
Private aRecSC7	:= {}

Private lTitNFeAuto	:= .F.

/*-----------------------------------------
	Carrega variaveis exclusivas do cliente 
	Gomes da Costa
------------------------------------------*/
Private C_TIPO_F1 := ""
Private C_FORN_F1 := ""
Private C_LOJA_F1 := ""
Private C_EST	  := ""	

Default lAuto	  := .F.


IF !EMPTY(cChvDanfe)
	
	DBSELECTAREA("Z10")
	Z10->(DBSETORDER(1))	//| Z10_FILIAL, Z10_CHVNFE, R_E_C_N_O_, D_E_L_E_T_
	IF Z10->(DBSEEK(XFILIAL("Z10")+cChvDanfe+cTpEntr,.F.))   
	
		IF Z10->Z10_TIPARQ <> "E" .AND. Z10->Z10_TIPARQ <> "C" //|Tipo Arquivo
			aRet[2]		:= "Arquivo não corresponde a uma nota fiscal de entrada."
			Return(aRet)
		ENDIF                
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Valida Empresa e Filial ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		IF Z10->Z10_CODEMP == SM0->M0_CODIGO .AND. ALLTRIM(Z10->Z10_CODFIL) == ALLTRIM(SM0->M0_CODFIL) .AND.(EMPTY(cEmpParam) .OR. SM0->(M0_CODFIL) $ cEmpParam)     //SM0->(M0_CODIGO+M0_CODFIL)

			cFullPath	+= ALLTRIM(Z10->Z10_ARQUIV)
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Transforma XML e OBJETO ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			oXML := XmlParserFile(cFullPath,"_",@cErro, @cAviso)
			IF VALTYPE(oXML) == "O" 		
			
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Divide objeto da XML para facilitar o Acesso aos dados ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//				oDANFE		:= oXML:_nfeproc:_NFe
				IF VALTYPE(XmlChildEx(oXML, "_NFEPROC")) == "O"     
					IF VALTYPE(XmlChildEx(oXML:_nfeproc, "_NFE")) == "O"
						oDANFE		:= oXML:_nfeproc:_NFe        
					ENDIF                                   
				ELSEIF VALTYPE(XmlChildEx(oXML, "_NFE")) == "O"
					oDANFE		:= oXML:_NFe
	
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Tratativa para leitura de CTe ³
				//³ Jonatas Oliveira - 02/08/2012 ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				ELSEIF VALTYPE(XmlChildEx(oXML, "_CTEPROC")) == "O"
					IF VALTYPE(XmlChildEx(oXML:_cteproc, "_CTE")) == "O"
						oDANFE		:= oXML:_cteproc:_CTe        
					ENDIF  	
				ENDIF

				IF VALTYPE(XmlChildEx(oXML, "_CTEPROC")) <> "O"
					oEmitente	:= oDANFE:_InfNfe:_Emit
					oIdent		:= oDANFE:_InfNfe:_IDE
					oDestino	:= oDANFE:_InfNfe:_Dest
					oTotal		:= oDANFE:_InfNfe:_Total
					oTransp	:= oDANFE:_InfNfe:_Transp
					oDet		:= oDANFE:_InfNfe:_Det  
				ELSE
					oEmitente	:= oDANFE:_InfCTe:_Emit
					oDest		:= oDANFE:_InfCTe:_REM
					oIdent		:= oDANFE:_InfCTe:_IDE
					oTotal		:= oDANFE:_InfCTe:_VPREST  
					oDet		:= oDANFE:_InfCTe:_VPREST 					                
					oImpCte	:= oDANFE:_InfCTe:_Imp			
				ENDIF 
				
				/*------------------------------------------------------ Augusto Ribeiro | 21/02/2020 - 7:51:46 AM
					Verifica se não existem mais de uma chave referenciada para filtrar nota fiscais de origem
				------------------------------------------------------------------------------------------*/
				IF !EMPTY(Z10->Z10_CHVREF)
					aChvRef	:= {}
					
					
					IF VALTYPE(XmlChildEx(oIdent, "_NFREF")) == "A"
						FOR nI := 1 to len(oIdent:_NFREF)
							IF VALTYPE(XmlChildEx(oIdent:_NFREF[nI], "_REFNFE")) == "O"				
								aadd(aChvRef, ALLTRIM(oIdent:_NFREF[nI]:_REFNFE:TEXT))								
							ENDIF
							
						NEXT 
						
					ELSEIF VALTYPE(XmlChildEx(oIdent, "_NFREF")) == "O"
						IF VALTYPE(XmlChildEx(oIdent:_NFREF, "_REFNFE")) == "O"				
							aadd(aChvRef, ALLTRIM(oIdent:_NFREF:_REFNFE:TEXT))
						ENDIF
					ENDIF 							
					
				ENDIF     				
				
				
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Verifica se existe informacoes adicionais ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				IF !EMPTY(Z10->Z10_CODADD)
					cInfAdic	:= MSMM(Z10->Z10_CODADD)
				ENDIF
				            
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Tratamento necessario pois quando a Danfe possui somente     ³
				//³ um item, esta propriedade vem como objeto ao inves de array. ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				IF VALTYPE(oDet) == "O"
					oDet	:= {oDet}
				ENDIF				
				
				IF !Z10->Z10_TIPNFE $ "B|D"

					//Verifica se fornecedor está bloqueado antes de abrir a tela de novo cadastro - Felipe Reis 20200522
					If !Empty(Z10->Z10_CNPJ)
						DbSelectArea("SA2")
						SA2->(DBSetOrder(3))//A2_FILIAL, A2_CGC, R_E_C_N_O_, D_E_L_E_T_
						If SA2->(DbSeek(xFilial("SA2")+Z10->Z10_CNPJ))
							If SA2->A2_MSBLQL == "1"
								aRet[2]	:= "Fornecedor " + SA2->A2_COD + "/" + SA2->A2_LOJA + " está bloqueado, favor verificar o cadastro."
								Return(aRet)	
							EndIf
						EndIf
					EndIf

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Busca Cadastro de Fornecedor ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					aRetFor	:= RetCliFor("SA2",Z10->Z10_CNPJ, Z10->Z10_RAZAO)
							
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Posiciona tabelas   ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	 
					DBSELECTAREA("SA2")
					SA2->(DBSETORDER(3))
					
					IF LEN(aRetFor)	== 3
						SA2->(DBGOTO(aRetFor[3]))
						lExistFor	:= .T.
					ELSE
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Realiza o cadastro do Fornecedor manualmente ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						IF lCadFor .AND. !(lAuto)
							IF Z10->Z10_TIPOPE == "0"/*0=Entrada;1=Saida*/ .AND. Z10->Z10_TIPARQ == "E"/*E=Entrada;S=Saida;C=CTE*/
								CadFornece(oDestino)
							ELSE
								CadFornece(oEmitente)
							ENDIF
							
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ Busca Cadastro de Fornecedor ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							aRetFor	:= RetCliFor("SA2",Z10->Z10_CNPJ, Z10->Z10_RAZAO)
							IF LEN(aRetFor)	== 3
								SA2->(DBGOTO(aRetFor[3]))
								lExistFor	:= .T.
							ENDIF						
						ENDIF
					ENDIF 
				ENDIF
				
					                                         
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Busca Tipo da Nota com base no CFOP                    ³
				//³ Verifica se utiliza Fornecedor ou Cliente              ³
				//³ Independente da utilizacao de Cliente ou Fornecedor, e ³
				//³ obrigatoria a existencia do fornecedor em funcao da    ³
				//³ amarracao do cadastro de produto x fornecedor          ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				IF !lExistFor .OR. (Z10->Z10_TIPNFE == "B" .or. Z10->Z10_TIPNFE == "D")
				
					lUtilCli	:= .T.									
					
					DBSELECTAREA("SA1")
					SA1->(DBSETORDER(3)) //| A1_FILIAL, A1_CGC
					IF SA1->(DBSEEK(XFILIAL("SA1")+Z10->Z10_CNPJ,.F.))
					
						cCliFor 	:= SA1->A1_COD
						cLoja		:= SA1->A1_LOJA 
						cUFCliFor	:= SA1->A1_EST 
					ELSE
						aRet[2]		+= "NFe Tipo "+Z10->Z10_TIPNFE+" - Cliente Não encontrado."+EOL
						cCliFor		:= ""
						cLoja		:= ""
						cUFCliFor	:= ""
					ENDIF

				ELSEIF lExistFor 
					cCliFor 	:= SA2->A2_COD
					cLoja		:= SA2->A2_LOJA 
					cUFCliFor	:= SA2->A2_EST	
				ELSEIF !lExistFor  
					aRet[2]	+= "NFe "+Z10->Z10_NUMNFE+" - Fornecedor Não encontrado."+EOL							
				ENDIF
				
				IF !EMPTY(cCliFor) .AND. (lExistFor .OR. lUtilCli)
				
					cSerie	:= Z10->Z10_SERIE
					cSerie	:= PADR(cSerie, TAMSX3("F1_SERIE")[1]," ")					
	
					//ÚÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ CABECALHO ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÙ
					aCabecNfe	:= {}
				   	AADD(aCabecNfe, {"F1_FILIAL"	,XFILIAL('SF1')					,NIL}) 
				 	AADD(aCabecNfe, {"F1_TIPO"		,Z10->Z10_TIPNFE				,NIL}) 
				 	IF Z10->Z10_TIPNFE == "1" .OR. Z10->Z10_TIPNFE == "N" .OR. Z10->Z10_TIPNFE == "B" .OR. Z10->Z10_TIPNFE == "D" //IF Z10->Z10_TIPOPE == "0"
						AADD(aCabecNfe, {"F1_FORMUL"	,'N'							,NIL}) 				 	
				 	ELSE
					   	AADD(aCabecNfe, {"F1_FORMUL"	,'S'							,NIL}) 
					ENDIF
					
					AADD(aCabecNfe, {"F1_DOC"		,Z10->Z10_NUMNFE				,NIL}) 
					AADD(aCabecNfe, {"F1_SERIE"		,cSerie							,NIL})
					//AADD(aCabecNfe, {"F1_SDOC"		,cSerie							,NIL})  
					AADD(aCabecNfe, {"F1_CHVNFE"	,cChvDanfe						,NIL}) 					
					AADD(aCabecNfe, {"F1_EMISSAO"	,Z10->Z10_DTNFE					,NIL}) 
					AADD(aCabecNfe, {"F1_FORNECE"	,cCliFor						,NIL}) 
					AADD(aCabecNfe, {"F1_LOJA"		,cLoja							,NIL}) 
					AADD(aCabecNfe, {"F1_EST"		,cUFCliFor						,NIL}) 
					
					IF VALTYPE(XmlChildEx(oXML, "_CTEPROC")) <> "O"
			 			AADD(aCabecNfe, {"F1_ESPECIE"	,cTipoNFE						,NIL}) 
	                ELSE
						AADD(aCabecNfe, {"F1_ESPECIE"	,cTipoCTE						,NIL}) 
					ENDIF 							
					
					AADD(aCabecNfe, {"F1_FRETE"		,Z10->Z10_VFRETE					,NIL}) 
					
					IF!EMPTY(Z10->Z10_MUORIT) 
						AADD(aCabecNfe, {"F1_MUORITR"		,Z10->Z10_MUORIT					,NIL})
					ENDIF 
					
					IF!EMPTY(Z10->Z10_MUDEST) 
						AADD(aCabecNfe, {"F1_MUDESTR"		,Z10->Z10_MUDEST					,NIL})
					ENDIF 	

					IF!EMPTY(Z10->Z10_UFDEST) 
						AADD(aCabecNfe, {"F1_UFDESTR"		,Z10->Z10_UFDEST					,NIL})
					ENDIF 					

					IF!EMPTY(Z10->Z10_UFORIT) 
						AADD(aCabecNfe, {"F1_UFORITR"		,Z10->Z10_UFORIT					,NIL})
					ENDIF 	
					
					IF Z10->Z10_TIPNFE == "D"  
						lVincOrig := .T.
					ENDIF 
										
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Cria Variaveis com a posicao do Array de cada campo do cabecalho ³
					//³ Exemplo: F1_DOC = nF1DOC | F1_SERIE = nF1SERIE                  ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ			
					/*
					FOR nY := 1 TO LEN(aCabecNfe)
						&("n"+REPLACE(aCabecNfe[nY, 1],"_",""))	:= nY
					NEXT nY
					*/
					
					DBSELECTAREA("Z11") 
					Z11->(DBSETORDER(1))	//| Z11_FILIAL, Z11_CHVNFE, Z11_TIPARQ, Z11_ITEM, R_E_C_N_O_, D_E_L_E_T_


					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ ITENS - DETALHE ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
					lTryAgain	:= .T.
					WHILE lTryAgain   
		
						lTryAgain	:= .F.    
						lAbort		:= .F.
						
						aItensNFe	:= {}
						aItensNcm	:= {}
						aProdFor	:= {}  
						aItemOr		:= {}
						
						nItensNF	:= 0
						nNFxPC		:= 0
						
						
						aAreaZ11	:= Z11->(GetArea())
					
						aPCNI 		:= {}	//pedido de compras não informado
						
						
						/*------------------------------------------------------ Augusto Ribeiro | 20/02/2020 - 1:21:05 PM
							Especifico Gomes da Costa
							Interface para seleção de Notas Fiscais de Origem
						------------------------------------------------------------------------------------------*/
						IF Z10->Z10_TIPNFE == "D" //.OR. Z10->Z10_TIPNFE == "B" 
							
							aRetVinc	:= U_CP01014(Z10->Z10_CHVNFE, aChvRef, Z10->Z10_DTNFE,cSerie, cCliFor, cLoja, Z10->Z10_TIPNFE)
							//aRetVinc	:= U_CP01014(Z10->Z10_CHVNFE, {Z10->Z10_CHVREF}, cSerie, cCliFor, cLoja, Z10->Z10_TIPNFE)
							//aRetVinc	:= U_CP01014(Z10->Z10_CHVNFE, {"42190802279324002007550010001266621004413549","42190702279324002007550010001261601004525325"})
							
							IF aRetVinc[1]
								aItensNFe	:= aClone(aRetVinc[3])
							ELSE
								aRet[2]	+= "NF de Origem:"+aRetVinc[2]
								lAbort := .T.
							Endif
						ENDIF
						
						IF Z10->Z10_TIPNFE <> "D" //.AND. Z10->Z10_TIPNFE <> "B" //| IFDEV DEVOLUCAO |
						
							Z11->(DBSEEK(Z10->(Z10_FILIAL+Z10_CHVNFE+Z10_TIPARQ)))				
							WHILE Z11->(!EOF()) .AND. Z11->(Z11_FILIAL+Z11_CHVNFE+Z11_TIPARQ) == Z10->(Z10_FILIAL+Z10_CHVNFE+Z10_TIPARQ)
								aLinhaNfe	:= {}   
								aPosIpi		:= {}   
								cProduto	:= ""   
								
								nQtdePri	:= 0
								nQtdeSeg	:= 0
								nVlrUni		:= 0
								nVlrTot		:= 0
								
								cPriUM		:= ""
								cSegUM		:= ""
								
								nItensNF++
								
	
								//incluída linha abaixo [Mauro Nagata, Compila, 20200213]
								//If !(Z10->Z10_TIPNFE $ "B.D")		//diferente tipo beneficiamento/devolução
								//IF Z10->Z10_TIPNFE <> "D"
									//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
									//³Verifica se o vinculo sera feito por Produto X Fornecedor³
									//³ou direto com o Pedido de Compra                         ³
									//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ    														
									IF lPcProdFor //Cadastro de Produto X Fornecedor com base no Ped. Compra							
		//								MsgInfo ( "Vinculo produto X Fornecedor Por PC", "PEDPXF" ) 																
											
										DBSELECTAREA("SC7")
										SC7->(DBSETORDER(1))//|C7_FILIAL+C7_NUM+C7_ITEM
										SC7->(DBGOTOP())
										lPCOK	:= .T.
										
										IF !EMPTY(Z11->Z11_NUMPC) .AND. !EMPTY(Z11->Z11_ITEMPC)
											IF SC7->(DBSEEK(XFILIAL("SC7")+Z11->(Z11_NUMPC+Z11_ITEMPC),.F.))
		
												//IF SC7->C7_PRECO == Z11->Z11_VLRUNI
												//substituída linha acima pela abaixo [Mauro Nagata, www.compila.com.br, 2020302]
												IF SC7->C7_PRECO >= Z11->Z11_VLRUNI
													
													//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
													//³ Adiciona RECNO SC7 para Query que vincula Pedido a NF |
													//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ   											
													aadd(aRecSC7,SC7->(RECNO()))                       
													
													//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
													//³ Busca - De Para de Produto ³
													//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ    
													DBSELECTAREA("SA5")   
				
													//nRecSA5	:= ProdFor( ALLTRIM(Z11->Z11_CODPRO), SA2->A2_COD, SA2->A2_LOJA)
													
													/*
													//Utiliza amarração de tabela produto x fornecedor da Gomes da Costa
													cProduto	:= U_CPGPfor( ALLTRIM(Z11->Z11_CODPRO), SA2->A2_COD, SA2->A2_LOJA)[3]
													//lPCOK		:= .T.
													*/
													//substituído bloco acima pela linha abaixo [Mauro Nagata, www.compila.com.br, 20200227]
													cProduto := SC7->C7_PRODUTO
			
													IF !empty(cProduto)
													
														IF ALLTRIM(cProduto) == ALLTRIM(SC7->C7_PRODUTO)
													
															DBSELECTAREA("SB1")
															SB1->(DBSETORDER(1)) //| 
															SB1->(DbSeek(xFilial("SB1")+cProduto))
														ELSE
															lAbort	:= .T.
															aRet[1]	:= .F.
															aRet[2]	+= CRLF + REPLICATE('-',80) + CRLF + "Prod. x Fornecedor existente diverge do item do Pedido de Compra: "+CRLF
															aRet[2]	+= "Item NF: "+alltrim(STR(Z11->Z11_ITEM))+" Prod.NF: "+ALLTRIM(Z11->Z11_CODPRO)+"  Prod. x Fornecedor [ZCC]: "+ALLTRIM(cProduto)+"  Prod. PC:"+ALLTRIM(SC7->C7_PRODUTO)+CRLF
														ENDIF
													ELSE
														//Utiliza amarração de tabela produto x fornecedor da Gomes da Costa
														aRetAux	:=  U_CPGPfor( ALLTRIM(Z11->Z11_CODPRO), SA2->A2_COD, SA2->A2_LOJA, SC7->C7_PRODUTO, .T.)
														
														IF aRetAux[1]
															cProduto	:=  aRetAux[3]
														ELSE
															lAbort	:= .T.
															aRet[1]	:= .F.
															aRet[2]	+= CRLF + REPLICATE('-',80) + CRLF + "Falha ao Gravar Produto X Fornecedor [A]: "+CRLF+aRetAux[2]
															
															//incluída linha abaixo [Mauro Nagata, www.compila.com.br, 20200227]
															lPCOK	:= .F.
														ENDIF
														
													ENDIF
												/*	
												ELSE 
													
													/*
													cAtencao	+= CRLF + REPLICATE('-',80) + CRLF + "Valor da Nota Fiscal difere do valor da Pedido de Compra. "+CRLF
													cAtencao	+= "Item NF: "+alltrim(STR(Z11->Z11_ITEM))+"  Valor NF: "+ALLTRIM(str(Z11->Z11_VLRUNI))+"  Valor PC:"+ALLTRIM(str(SC7->C7_PRECO))+CRLF
													*/
													/*
													//substituído bloco acima pelo abaixo [Mauro Nagata, www.compila.com.br, 20200302]
													//incluída linha abaixo [Mauro Nagata, www.compila.com.br, 20200303]
													//cAtencao	+= "NÃO PERMITIDO"
													//cAtencao	+= CRLF + Replicate('-',20) + CRLF 
													cAtencao	+= 	"NÂO É PERMITIDO que o valor unitário da nota fiscal maior que do pedido de compras. " + CRLF
													cAtencao	+= 	"   Item NF: " + AllTrim(Str(Z11->Z11_ITEM)) + "     Pedido/Item: " + SC7->C7_NUM + " / " + SC7->C7_ITEM + CRLF  
													cAtencao	+= 	"     Valor NF: " + AllTrim(Transform(Z11->Z11_VLRUNI,"@E 999,999,999.99")) +;
													 				"     PC:" + AllTrim(Transform(SC7->C7_PRECO, "@E 999,999,999.99")) 
													lPCOK	:= .F.
												ENDIF
												*/
												//substituído bloco acima pelo abaixo [Mauro Nagata, www.compila.com.br, 20200307]
												EndIf
												IF SC7->C7_PRECO < Z11->Z11_VLRUNI
													cAtencao	+= 	"INCONSISTENTE O valor unitário da nota fiscal é maior que do pedido de compras. " + CRLF
													cAtencao	+= 	"   Item NF: " + AllTrim(Str(Z11->Z11_ITEM)) + "     Pedido/Item: " + SC7->C7_NUM + " / " + SC7->C7_ITEM + CRLF
													cAtencao	+= 	"     Produto NF: " + AllTrim(Z11->Z11_CODPROD) + "     PC: " + AllTrim(SC7->C7_PRODUTO) + CRLF
													//incluído bloco abaixo [Mauro Nagata, www.compila.com.br, 20200302]
													/*  
													cAtencao	+= 	"     Valor NF: " + AllTrim(Transform(Z11->Z11_VLRUNI,"@E 999,999,999.99")) +;
													 				"     PC:" + AllTrim(Transform(SC7->C7_PRECO, "@E 999,999,999.99")) +;
													 				"     # " + AllTrim(Transform(Z11->Z11_VLRUNI - SC7->C7_PRECO,"@E 999,999,999.99")) + CRLF
													*/
													cAtencao	+= 	"     Valor NF: " + AllTrim(Transform(Z11->Z11_VLRUNI,"@E 999,999,999.99")) +;
													 				"     PC:" + AllTrim(Transform(SC7->C7_PRECO, "@E 999,999,999.99")) +;
													 				"     Diferença: " + AllTrim(Transform(Z11->Z11_VLRUNI - SC7->C7_PRECO,"@E 999,999,999.99")) + CRLF
													//fim bloco [Mauro Nagata, www.compila.com.br, 20200311]
													 				
													lPCOK	:= .F.
												EndIf
												//fim bloco [Mauro Nagata, www.compila.com.br, 20200307]
												
												//incluído bloco abaixo [Mauro Nagata, www.compila.com.br, 20200302]
												//quantidade do XML diferente do pedido de compras
												If  Z11->Z11_QUANT != (SC7->C7_QUANT-SC7->C7_QUJE-SC7->C7_QTDACLA)
													cAtencao	+= 	"ALERTA Quantidade da nota fiscal é diferente do pedido de compras" + CRLF
													cAtencao	+= 	"   Item NF: " + AllTrim(Str(Z11->Z11_ITEM)) + "     Pedido/Item: " + SC7->C7_NUM + " / " + SC7->C7_ITEM + CRLF
													cAtencao	+= 	"     Produto NF: " + AllTrim(Z11->Z11_CODPROD) + "     PC: " + AllTrim(SC7->C7_PRODUTO) + CRLF
													/*
													cAtencao	+= 	"     Qtd NF: " + AllTrim(Str(Z11->Z11_QUANT)) + "     PC: " + AllTrim(Str((SC7->C7_QUANT-SC7->C7_QUJE-SC7->C7_QTDACLA))) +;
																	"     # " + AllTrim(Str(Z11->Z11_QUANT - (SC7->C7_QUANT-SC7->C7_QUJE-SC7->C7_QTDACLA))) + CRLF
													*/  
													//substituído bloco acima pelo abaixo [Mauro Nagata, www.compila.com.br, 20200311]
													cAtencao	+= 	"     Qtd NF: " + AllTrim(Str(Z11->Z11_QUANT)) + "     PC: " + AllTrim(Str((SC7->C7_QUANT-SC7->C7_QUJE-SC7->C7_QTDACLA))) +;
																	"     Diferença " + AllTrim(Str((SC7->C7_QUANT-SC7->C7_QUJE-SC7->C7_QTDACLA) - Z11->Z11_QUANT )) + CRLF
													//fim bloco [Mauro Nagata, www.compila.com.br, 20200311]
												EndIf
												
												If  Z11->Z11_QUANT > (SC7->C7_QUANT-SC7->C7_QUJE-SC7->C7_QTDACLA)
													cAtencao	+= 	"INCONSISITENTE Quantidade da nota fiscal é maior que do pedido de compras" + CRLF
													cAtencao	+= 	"   Item NF: " + AllTrim(Str(Z11->Z11_ITEM)) + "     Pedido/Item: " + SC7->C7_NUM + " / " + SC7->C7_ITEM + CRLF
													cAtencao	+= 	"     Produto NF: " + AllTrim(Z11->Z11_CODPROD) + "     PC: " + AllTrim(SC7->C7_PRODUTO) + CRLF
													/*
													cAtencao	+= 	"     Qtd NF: " + AllTrim(Str(Z11->Z11_QUANT)) + "     PC: " + AllTrim(Str((SC7->C7_QUANT-SC7->C7_QUJE-SC7->C7_QTDACLA))) +;
																	"     # " + AllTrim(Str(Z11->Z11_QUANT - (SC7->C7_QUANT-SC7->C7_QUJE-SC7->C7_QTDACLA))) + CRLF
													*/
													//substituído bloco acima pelo abaixo [Mauro Nagata, www.compila.com.br, 20200311]
													cAtencao	+= 	"     Qtd NF: " + AllTrim(Str(Z11->Z11_QUANT)) + "     PC: " + AllTrim(Str((SC7->C7_QUANT-SC7->C7_QUJE-SC7->C7_QTDACLA))) +;
																	"     Diferença: " + AllTrim(Str((SC7->C7_QUANT-SC7->C7_QUJE-SC7->C7_QTDACLA) - Z11->Z11_QUANT)) + CRLF
													//fim bloco [Mauro Nagata, www.compila.com.br, 20200311]
												EndIf
												
												
												//valor do XML menor que do pedido de compras
												If  SC7->C7_PRECO > Z11->Z11_VLRUNI
													//cAtencAux	:= 	"ALERTA O valor unitário da nota fiscal é menor que do pedido de compras" + CRLF
													//substituída linha acima pela abaixo [Mauro Nagata, www.compila.com.br, 20200311]
													cAtencAux	:= 	"O valor unitário da nota fiscal é menor que do pedido de compras" + CRLF
													cAtencAux	+= 	"   Item NF: " + AllTrim(Str(Z11->Z11_ITEM)) + "     Pedido/Item: " + SC7->C7_NUM + " / " + SC7->C7_ITEM + CRLF
													cAtencAux	+= 	"     Produto NF: " + AllTrim(Z11->Z11_CODPROD) + "     PC: " + AllTrim(SC7->C7_PRODUTO) + CRLF
													/*
													cAtencAux	+= 	"     Valor NF: " + AllTrim(Transform(Z11->Z11_VLRUNI,"@E 999,999,999.99")) +;
													 				"     PC:" + AllTrim(Transform(SC7->C7_PRECO, "@E 999,999,999.99")) +;
													 				"     # " + AllTrim(Transform(Z11->Z11_VLRUNI - SC7->C7_PRECO,"@E 999,999,999.99")) + CRLF
													*/
													//substituído bloco acima pelo abaixo [Mauro Nagata, www.compila.com.br, 20200311]
													cAtencAux	+= 	"     Valor NF: " + AllTrim(Transform(Z11->Z11_VLRUNI,"@E 999,999,999.99")) +;
													 				"     PC:" + AllTrim(Transform(SC7->C7_PRECO, "@E 999,999,999.99")) +;
													 				"     Diferença: " + AllTrim(Transform(Z11->Z11_VLRUNI - SC7->C7_PRECO,"@E 999,999,999.99")) + CRLF
													//fim bloco [Mauro Nagata, www.compila.com.br, 20200311]
													
													
													 				
													lAviso := Aviso("Deseja Permitir ?", cAtencAux,{"Não","Sim"},3) = 2		//.T., permitir .F., não permitir
													
													If lAviso
														cAtencao += "ALERTA O valor unitário da nota fiscal é menor que do pedido de compras" + CRLF
													Else
														cAtencao += "INCONSISTENTE O valor unitário da nota fiscal é menor que saldo do pedido de compras" + CRLF
														lPCOK	:= .F.
													EndIf
													
													
													cAtencao	+= 	"   Item NF: " + AllTrim(Str(Z11->Z11_ITEM)) + "     Pedido/Item: " + SC7->C7_NUM + " / " + SC7->C7_ITEM + CRLF
													cAtencao	+= 	"     Produto NF: " + AllTrim(Z11->Z11_CODPROD) + "     PC: " + AllTrim(SC7->C7_PRODUTO) + CRLF
													/*
													cAtencao	+= 	"     Valor NF: " + AllTrim(Transform(Z11->Z11_VLRUNI,"@E 999,999,999.99")) +;
													 				"     PC:" + AllTrim(Transform(SC7->C7_PRECO, "@E 999,999,999.99")) +;
													 				"     # " + AllTrim(Transform(Z11->Z11_VLRUNI - SC7->C7_PRECO,"@E 999,999,999.99")) + CRLF
													*/
													cAtencao	+= 	"     Valor NF: " + AllTrim(Transform(Z11->Z11_VLRUNI,"@E 999,999,999.99")) +;
													 				"     PC:" + AllTrim(Transform(SC7->C7_PRECO, "@E 999,999,999.99")) +;
													 				"     Diferença: " + AllTrim(Transform(Z11->Z11_VLRUNI - SC7->C7_PRECO,"@E 999,999,999.99")) + CRLF
													//fim bloco [Mauro Nagata, www.compila.com.br, 20200311]
													  
												EndIf
												//fim bloco [Mauro Nagata, www.compila.com.br, 20200302]
											ELSE
												lPCOK	:= .F.
											ENDIF
										ELSE
											lPCOK	:= .F.
										ENDIF
										
										IF lPCOK
											nNFxPC++
										ELSE
										
											//| Caso nem todos os itens estejam OK, força apresentacao da interface para selecao do PC|
											aRecSC7	:= {}
											
											//incluído bloco abaixo [Mauro Nagata, Compila, 20200214]
											//armazenar os produtos que não tem número e item do pedido de compras											
											If Empty(Z11->(Z11_NUMPC+Z11_ITEMPC))
												aAdd(aPCNI,AllTrim(Z11->Z11_CODPRO))
											EndIf
											//fim bloco [Mauro Nagata, Compila, 20200214]
																										
		                                	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
											//³ Posiciona no cod. Produto tabela Z11 ³
											//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				
											//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
											//³ Busca - De Para de Produto ³
											//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ    
											
											cProduto	:= U_CPGPfor( ALLTRIM(Z11->Z11_CODPRO), SA2->A2_COD, SA2->A2_LOJA)[3]
											IF !empty(cProduto)
												DBSELECTAREA("SB1")
												SB1->(DBSETORDER(1)) //| 
												SB1->(DbSeek(xFilial("SB1")+cProduto))
											ELSE
												lAbort	:= .T.
												nPosPro := Ascan(aProdFor,{ |x| alltrim(x[1] ) == ALLTRIM( Z11->Z11_CODPRO ) } )
												
												IF nPosPro == 0 
													aadd(aProdFor,{ALLTRIM(Z11->Z11_CODPRO),ALLTRIM(Z11->Z11_DESPRO), AllTrim(RemovChar(Z11->Z11_UM))})
												ENDIF
												
												Z11->(DBSKIP())
												LOOP
											ENDIF
										ENDIF                                 
									ELSE
										//|Jonatas 10/03/2014							
										IF lProdCli //|Utiliza produto do cliente ou fornecedor 
											//|Monta codigo de produto estruturado
											//|Ref	- 1 ou 2 - Cliente ou Fornecedor
											//|Codigo SA1 ou SA2 
											//|Loja
											//|Sufixo
											
											DBSELECTAREA("SB1")
											SB1->(DBSETORDER(1))									
											
											IF lUtilCli .AND. !EMPTY(cCliFor) //|Cliente
												//cProdEstr := "2"+cCliFor+cLoja+PADR(Z11->Z11_CODPRO,TAMSX3("B1_COD")[1]-9) 									
												cProdEstr := LEFT(Z11->Z11_CODPRO,TAMSX3("B1_COD")[1])
											ELSEIF !lUtilCli .AND. !EMPTY(cCliFor)
											
												//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
												//nRecSA5		:= ProdFor( ALLTRIM(Z11->Z11_CODPRO), SA2->A2_COD, SA2->A2_LOJA)
												//³ Interface para cadastro do produto x fornecedor ³
												//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
												nRecSA5		:= ProdFor( ALLTRIM(Z11->Z11_CODPRO), SA2->A2_COD, SA2->A2_LOJA)
												IF nRecSA5 > 0
													DBSELECTAREA("SA5")
													SA5->(DBGOTO(nRecSA5))
													
													IF SB1->(DBSEEK(XFILIAL("SB1")+SA5->A5_PRODUTO))
														cProdEstr := SB1->B1_COD
													ELSE
														cProdEstr := MNTCODPR()
														cProdEstr += SPACE(TAMSX3("B1_COD")[1]-LEN(cProdEstr))
													ENDIF 	
												ELSE															
													IF SB1->(DBSEEK(XFILIAL("SB1")+ALLTRIM(Z11->Z11_CODPRO))) .AND. ALLTRIM(SB1->B1_POSIPI) == ALLTRIM(Z11->Z11_POSIPI)
														cProdEstr := SB1->B1_COD												
													ELSEIF SB1->(DBSEEK(XFILIAL("SB1")+ALLTRIM(Z11->Z11_CODPRO)))
														cProdEstr := MNTCODPR()	
														cProdEstr += SPACE(TAMSX3("B1_COD")[1]-LEN(cProdEstr))	 
													ELSE
														cProdEstr := LEFT(Z11->Z11_CODPRO,TAMSX3("B1_COD")[1])	
													ENDIF 
												
													//cProdEstr := MNTCODPR()//"1"+cCliFor+cLoja+PADR(Z11->Z11_CODPRO,TAMSX3("B1_COD")[1]-9) 												
												ENDIF 		
											ENDIF	           
											
											lMsErroAuto := .F.                                       
											
											IF SB1->(!DBSEEK(XFILIAL("SB1")+cProdEstr))									
												aDadosCad :=  {}
																				
												aadd(aDadosCad, {"B1_COD"	 ,cProdEstr					,Nil})
												aadd(aDadosCad, {"B1_DESC"   ,ALLTRIM(Z11->Z11_DESPRO)	,Nil})
												aadd(aDadosCad, {"B1_UM"     ,ALLTRIM(Z11->Z11_UM)		,Nil})    
												aadd(aDadosCad, {"B1_IPI"    ,Z11->Z11_IPIALQ			,Nil})
												aadd(aDadosCad, {"B1_POSIPI" ,ALLTRIM(Z11->Z11_POSIPI)	,Nil})
												aadd(aDadosCad, {"B1_SEGUM"  ,ALLTRIM(Z11->Z11_UM)		,Nil})
												aadd(aDadosCad, {"B1_LOCPAD" ,'01'						,Nil})
												aadd(aDadosCad, {"B1_IRRF"   ,'N'						,Nil}) 
												aadd(aDadosCad, {"B1_ORIGEM" ,ALLTRIM(Z11->Z11_ICORIG)	,Nil})  //Alterado por Eduardo Felipe em 18/06/14 - Adicionar a Origem do produto
												
												
												lMSHelpAuto := .F.
												lAutoErrNoFile := .T.
												
												//Chama rotina automatica do cadastro de produto
												MSExecAuto({|x,y| Mata010(x,y)},aDadosCad,3)   
												
												/*Caso ocorra erro no EXECAUTO Apresenta Interface para cadastro*/
												IF lMsErroAuto
			
				//									IF VALTYPE(XmlChildEx(oDet,"_PROD")) <> 'U'    
												
													cAliasImp	:= "SB1"
													cFuncao		:= "MATA010"	//| Cadastro de Produtos
													cTituloImp	:= "Cadastro de Produtos"  
													aDadosCad	:= {} //estrutura do array {{"B1_DESC", "MAX FOREVER", Nil}}  
													
													aadd(aDadosCad, {"B1_COD"	 ,cProdEstr					,Nil})
													aadd(aDadosCad, {"B1_DESC"   ,ALLTRIM(Z11->Z11_DESPRO)	,Nil})
													aadd(aDadosCad, {"B1_UM"     ,ALLTRIM(Z11->Z11_UM)		,Nil})                                   
													aadd(aDadosCad, {"B1_IPI"    ,Z11->Z11_IPIALQ			,Nil})
													aadd(aDadosCad, {"B1_POSIPI" ,ALLTRIM(Z11->Z11_POSIPI)	,Nil})
													aadd(aDadosCad, {"B1_SEGUM"  ,ALLTRIM(Z11->Z11_UM)		,Nil})
													aadd(aDadosCad, {"B1_LOCPAD" ,'01'						,Nil})
													aadd(aDadosCad, {"B1_IRRF"   ,'N'						,Nil})
													aadd(aDadosCad, {"B1_ORIGEM" ,ALLTRIM(Z11->Z11_ICORIG)	,Nil})  //Alterado por Eduardo Felipe em 18/06/14 - Adicionar a Origem do produto
		
													lAbortProd := U_cpGrvCad(cAliasImp, cTituloImp, cFuncao, aDadosCad)          
												ENDIF 										 
		                                    ENDIF 
		                                    
		                                    									
											IF 	SB1->(DBSEEK(XFILIAL("SB1")+cProdEstr)) 
												//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
												//³ Busca - De Para de Produto ³
												//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ    
												DBSELECTAREA("SA5")   
												
												
												nRecSA5	:= ProdFor( ALLTRIM(Z11->Z11_CODPRO), SA2->A2_COD, SA2->A2_LOJA)
												
												lMsErroAuto := .F.
												
												IF nRecSA5 > 0			
													SA5->(DBGOTO(nRecSA5))
													cProduto 	:= SA5->A5_PRODUTO	
												ELSE
													SA5->(DBSETORDER(1)) //| A5_FILIAL, A5_FORNECE, A5_LOJA, A5_PRODUTO			
													IF SA5->(!DBSEEK(XFILIAL("SA5")+cCliFor+cLoja+cProdEstr,.F.))	 
														lAbort	:= .T.
														
														nPosPro := Ascan(aProdFor,{ |x| alltrim(x[1] ) == ALLTRIM( Z11->Z11_CODPRO ) } )
												
														IF nPosPro == 0  
															aadd(aProdFor,{ALLTRIM(Z11->Z11_CODPRO),ALLTRIM(Z11->Z11_DESPRO), AllTrim(RemovChar(Z11->Z11_UM))})	
														ENDIF 
		
														RegTomemory("SA5",.T.)
														nOpc	:= 3	  
														
														DBSELECTAREA("SA2")
														SA2->(DBSETORDER(1))
														SA2->(DBSEEK(XFILIAL("SA2")+cCliFor+cLoja))  											
		
														nOpc := 3
														oModel := Nil
														
														oModel := FWLoadModel('MATA061')
														
														oModel:SetOperation(nOpc)
														oModel:Activate()
														
														//Cabeçalho
														oModel:SetValue('MdFieldSA5','A5_PRODUTO',cProdEstr )
														
														//Grid
														oModel:SetValue('MdGridSA5','A5_FORNECE', cCliFor )
														oModel:SetValue('MdGridSA5','A5_LOJA' 	, cLoja )	
														oModel:SetValue('MdGridSA5','A5_CODPRF' 	,Z11->Z11_CODPRO)																													
														
														If oModel:VldData()
															oModel:CommitData()
														Else
															aRet[1]	:= .F.
															aRet[2]	+= EOL+REPLICATE('-',80)+EOL+"Falha ao Gravar Produto X Fornecedor:2"
														Endif
														
														oModel:DeActivate()
														
														oModel:Destroy()
														
												    ELSE
													     cProduto 	:= SB1->B1_COD
												    ENDIF 
												    
		//											IF lMsErroAuto     
		//												//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//												//³ Realiza rollback ³
		//												//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		//												aRet[1]	:= .F.
		//												aRet[2]	+= EOL+REPLICATE('-',80)+EOL+"Falha ao Gravar Produto X Fornecedor:"
		//												                       		
		//												IF !EMPTY(NOMEAUTOLOG())
		//													cLOGEXEC	:= MemoRead(NOMEAUTOLOG())							
		//													aRet[2]		+= EOL+alltrim(cLOGEXEC)
		//												ENDIF
		//											ENDIF
																								
													
		//											Z11->(DBSKIP())
		//											LOOP
												ENDIF		
											ELSE
												//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
												//³ Realiza rollback ³
												//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
											
												lAbort := .T.
												
												aRet[1]	:= .F.
												aRet[2]	+= EOL+REPLICATE('-',80)+EOL+"Falha ao Gravar Produto:"+cProdEstr+EOL
												                       		
												IF !EMPTY(NOMEAUTOLOG())
													cLOGEXEC	:= MemoRead(NOMEAUTOLOG())							
													aRet[2]		+= EOL+alltrim(cLOGEXEC)
												ENDIF
												Z11->(DBSKIP())
												LOOP																		
											ENDIF
		//									ENDIF 
										//ELSEIF 
																			
										ELSE
									
											//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
											//³ Posiciona no cod. Produto tabela Z11 ³
											//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				
											//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
											//³ Busca - De Para de Produto ³
											//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ    
											cProduto	:= U_CPGPfor( ALLTRIM(Z11->Z11_CODPRO), SA2->A2_COD, SA2->A2_LOJA)[3]
											IF !empty(cProduto)
												DBSELECTAREA("SB1")
												SB1->(DBSETORDER(1)) //| 
												SB1->(DbSeek(xFilial("SB1")+cProduto))
	
											ELSE
												lAbort	:= .T.
												
												nPosPro := Ascan(aProdFor,{ |x| alltrim(x[1] ) == ALLTRIM( Z11->Z11_CODPRO ) } )
												
												IF nPosPro == 0 
													aadd(aProdFor,{ AllTrim(Z11->Z11_CODPRO), AllTrim(Z11->Z11_DESPRO), AllTrim(RemovChar(Z11->Z11_UM)) } )
												ENDIF 
												
												
												Z11->(DBSKIP())
												LOOP
											ENDIF
										ENDIF
									ENDIF														
								
															
									//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
									//³ Verifica se unidade de medida existe  ³
									//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		                            cPriUM		:= ALLTRIM(Z11->Z11_UM)
		                            //| Remove caracteres especiais.
		                            cPriUM		:= ALLTRIM(RemovChar(cPriUM))
									
									//incluída linha abaixo [Mauro Nagata, Compila, 20200214]
									If !(Z10->Z10_TIPNFE $ "B.D")		//diferente tipo beneficiamento/devolução
										DBSELECTAREA("SAH")
										SAH->(DBSETORDER(1))
										IF !(SAH->(DBSEEK(XFILIAL("SAH")+cPriUM,.F.))) .OR. LEN(cPriUM) > TAMSX3("AH_UNIMED")[1]
										
											DBSELECTAREA("Z09")
											Z09->(DBSETORDER(1))
											IF !(Z09->(DBSEEK(XFILIAL("Z09")+cPriUM,.F.)) .AND. ALLTRIM(Z09->Z09_UMDE) == ALLTRIM(cPriUM))
											
												//aRet[2]	+=  CRLF +"Unidade de Medida Inválida: "+cPriUM+" [1]"+EOL
												aRet[2]	+= CRLF + "Unidade de Medida Inválida. ERRO[1] "+CRLF+" U.M. DANFE: "+AllTrim(cPriUM)+CRLF											
												lAbort	:= .T.
											ENDIF
										ENDIF							
									//incluída linha abaixo [Mauro Nagata, Compila, 20200214]
									EndIf
									
									nQtdePri	:= Z11->Z11_QUANT      
									
									nVlrUni		:= Z11->Z11_VLRUNI	 
									nVlrTot		:= Z11->Z11_VLRTOT
									    
									nQtdePri	:= Round(nQtdePri,nDQUANT)
									nVlrUni		:= Round(nVlrUni,nDVUNIT)
									nVlrTot		:= Round(nVlrTot,nDTOTAL)
									
		
									//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
									//³ Compara unidade de medida com cadastro de produto e ³
									//³ Realiza tratamentos se necessario                   ³
									//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
									IF cPriUM == ALLTRIM(SB1->B1_UM)
										cSegUM	:= ""
		
									ELSEIF cPriUM == SB1->B1_SEGUM
		
										cSegUM		:= cPriUM
										nQtdeSeg	:= nQtdePri
										
										//incluída linha abaixo [Mauro Nagata, Compila, 20200214]
										If !(Z10->Z10_TIPNFE $ "B.D")		//diferente tipo beneficiamento/devolução                
											IF EMPTY(SB1->B1_TIPCONV) .OR. EMPTY(SB1->B1_CONV)
												//aRet[2]	+= "Unidade de Medida Inválida: "+cPriUM+" - "+ALLTRIM(cProduto)+" | Tipo de conversao/Fator não informado"+" [2]"+EOL
												aRet[2]	+= CRLF + "Unidade de Medida Inválida. ERRO[2] "+CRLF+" Prod.: "+ALLTRIM(cProduto)+", U.M. DANFE: "+AllTrim(cPriUM)+"| Tipo de conversao/Fator não informado"+CRLF
												lAbort	:= .T.
											ENDIF
										//incluída linha abaixo [Mauro Nagata, Compila, 20200214]
										EndIf
																	                
										IF SB1->B1_TIPCONV == "M"
			
											nQtdePri	:= Round(nQtdeSeg/SB1->B1_CONV, nDQUANT)
											nVlrUni		:= Round(nVlrUni*SB1->B1_CONV,nDVUNIT)
		
										ELSEIF SB1->B1_TIPCONV == "D"
										
											nQtdePri	:= nQtdeSeg*SB1->B1_CONV             
											nVlrUni		:= Round(nVlrUni/SB1->B1_CONV,nDVUNIT)
										ENDIF                                                           
										                  
										                  
										IF nQtdePri*nVlrUni  == nVlrTot
											nVlrTot		:= nQtdePri*nVlrUni
										ELSE
											//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
											//³ Acumula diferencas ³
											//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
											nDifUM		+= (nQtdePri*nVlrUni)-nVlrTot
											
											nVlrTot		:= nQtdePri*nVlrUni
										ENDIF
																		
									ELSE
										
										//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
										//³ Realiza a conversao da Unidade de Medida de acordo com a ³
										//³ tabela de conversoes                                     ³
										//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
										aConvUM		:= U_CP01003A(cPriUM, ALLTRIM(SB1->B1_UM), nQtdePri, nVlrUni)
		
										IF aConvUM[1] > 0
		
											nQtdePri	:= Round(aConvUM[1],nDQUANT)									
											nVlrUni		:= Round(aConvUM[2],nDVUNIT) 
											
											IF nQtdePri*nVlrUni  == nVlrTot
												nVlrTot		:= nQtdePri*nVlrUni
											ELSE
												//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
												//³ Acumula diferencas ³
												//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
												nDifUM		+= nVlrTot-(nQtdePri*nVlrUni)
												
												nVlrTot		:= nQtdePri*nVlrUni
											ENDIF									
										ELSE
											//aRet[2]	+= "Unidade de Medida Inválida. Prod.: "+ALLTRIM(cProduto)+", U.M.: "+ALLTRIM(SB1->B1_UM)+"   X   U.M.DANFE:  "+alltrim(cPriUM)+" [3]"+EOL
											//substituída linha acima pelo abaixo [Mauro Nagata, Compila, 20200214]
											aRet[2]	+= CRLF + "Unidade de Medida Inválida. ERRO[3] "+CRLF+" Prod.: "+ALLTRIM(cProduto)+", U.M. Prod: "+AllTrim(SB1->B1_UM)+"   X   U.M. Danfe:  "+AllTrim(cPriUM)+CRLF
											lAbort	:= .T.
										ENDIF								
									ENDIF
								//ENDIF
								
								
								
	//							/*----------------------------------------
	//								06/06/2019 - Jonatas Oliveira - Compila
	//								Realiza validação se lote está preenchido
	//							------------------------------------------*/
	//							IF !lControL .AND. EMPTY(Z11->Z11_LOTECT) .AND. EMPTY(Z11->Z11_DTVALI) .AND. !lAbort
	//								IF SB1->(DBSEEK(XFILIAL("SB1")+cProduto)) .AND. SB1->B1_RASTRO == "L"
	//									lAbort := .T.								
	//									aRet[2]	+= "Produto com controle de lote. Necessário informar Lote e Validade: " + ALLTRIM(cProduto) +EOL
	//								ENDIF 	
	//							ENDIF 
								
								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
								//³ Converte CFOP de Saida para Entrada ³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
								cCFOP	:= Z11->Z11_CFOP
								cCFOP	:= U_CP0102CF(cCFOP)
																	
								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
								//³ Monta linha ³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							   	AADD(aLinhaNfe, {"D1_FILIAL"	,XFILIAL('SD1')		  		,NIL}) 
							 	AADD(aLinhaNfe, {"D1_DOC"		,Z10->Z10_NUMNFE  			,NIL}) 
							   	AADD(aLinhaNfe, {"D1_SERIE"		,cSerie						,NIL}) 
								AADD(aLinhaNfe, {"D1_FORNECE"	,cCliFor					,NIL}) 
								AADD(aLinhaNfe, {"D1_LOJA"		,cLoja						,NIL})
								
								AADD(aLinhaNfe, {"D1_COD" 		,cProduto 					,NIL})   
								AADD(aLinhaNfe, {"D1_CF" 		,cCFOP						,NIL})   							
								
								IF !EMPTY(cSegUM)
									AADD(aLinhaNfe, {"D1_QTSEGUM"	,nQtdeSeg				,NIL}) 
								ENDIF                                                             
								
								AADD(aLinhaNfe, {"D1_QUANT"		,nQtdePri					,NIL})
								AADD(aLinhaNfe, {"D1_VUNIT"		,nVlrUni					,NIL}) 
								AADD(aLinhaNfe, {"D1_TOTAL"		,nVlrTot					,NIL}) 
								
								cTES := ""
								
								IF lDocEnt //.AND. ! lVincOrig					
									IF ! lVincOrig								
										/*----------------------------------------
											28/06/2019 - Jonatas Oliveira - Compila
											Verifica se TES está vinculada ao Produto
										------------------------------------------*/
										IF lTesProd
											IF !EMPTY(SB1->B1_TE)
												cTES := SB1->B1_TE
											ENDIF 
										ENDIF
										
										IF EMPTY(cTES)
											/*----------------------------------------
												06/06/2019 - Jonatas Oliveira - Compila
												Identifica a TES a ser utilizada  
											------------------------------------------*/						
											DBSELECTAREA("Z07")	
											Z07->(DBSETORDER(1)) //| Z07_FILIAL, Z07_TIPO, Z07_CFOP, Z07_ITEM
										                                        
											IF Z07->(DBSEEK(XFILIAL("Z07")+"E"+RIGHT(alltrim(cCFOP),3)))
												WHILE Z07->(!EOF()) .AND. Z07->Z07_CFOP == RIGHT(alltrim(cCFOP),3)
												
													IF &(ALLTRIM(Z07->Z07_FILTRO))
														cTES	:= Z07->Z07_TES
														EXIT
													ENDIF
															         
													Z07->(DBSKIP())
												ENDDO
											ENDIF 
										ENDIF 
										
										/*----------------------------------------
											19/07/2019 - Jonatas Oliveira - Compila
											Ponto de entrada para atribuição de TES
										------------------------------------------*/
										IF EXISTBLOCK("CP0102TS")
											cTES	:= U_CP0102TS(@cTES)
										ENDIF
										 		
		//								cTES	:= U_CP01009T("E", , aChave)    
										AADD(aLinhaNfe,{ "D1_TES", cTES , nil })
										
										//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
										//³ Verifica se a TES Gera - DUPLICATA ³
										//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
										DBSELECTAREA("SF4")
										SF4->(DBSETORDER(1))   //| F4_FILIAL, F4_CODIGO
								
										IF SF4->(DBSEEK(XFILIAL("SF4") + cTES))
											IF SF4->F4_DUPLIC == "S"
												lTitNFeAuto	:= .T.
											ENDIF
													         
	//										Z07->(DBSKIP())
										ENDIF 
									ENDIF 
											
	//								cTES	:= U_CP01009T("E", , aChave)    
									AADD(aLinhaNfe,{ "D1_TES", cTES , nil })
									
									//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
									//³ Verifica se a TES Gera - DUPLICATA ³
									//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
									DBSELECTAREA("SF4")
									SF4->(DBSETORDER(1))   //| F4_FILIAL, F4_CODIGO
							
									IF SF4->(DBSEEK(XFILIAL("SF4") + cTES))
										IF SF4->F4_DUPLIC == "S"
											lTitNFeAuto	:= .T.
										ENDIF
										
									ENDIF
									
									/*----------------------------------------
										06/06/2019 - Jonatas Oliveira - Compila
										Tratamento para Nota fiscal de Devolucao
									------------------------------------------*/
									IF Z10->Z10_TIPNFE == "D"  
									
										IF !EMPTY(Z10->Z10_CHVREF)
																										
																					
											/*----------------------------------------
												06/06/2019 - Jonatas Oliveira - Compila
												Busca Nota e Item para amarrar a devolucao
											------------------------------------------*/
											aDanfeOrig		:= {}
											aDanfeOrig		:= U_CP01G05(Z10->Z10_CHVREF, cProduto) 
											
											IF LEN(aDanfeOrig)	> 0 		
												AADD(aLinhaNfe,{"D1_NFORI"		, aDanfeOrig[1] , nil }) 
												AADD(aLinhaNfe,{"D1_NFSERIORI"	, aDanfeOrig[2] , nil })
												AADD(aLinhaNfe,{"D1_NFITEMORI"	, aDanfeOrig[3] , nil })	
											ENDIF
										ENDIF  
												
									ENDIF							
							
									//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
									// Se For uma entrada de uma nota	³ 
									// que necessite vincular origem	³
									// entra na execeção abaixo			³
									//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
									IF lVincOrig  .and. !EMPTY(Z10->Z10_CHVREF)
												
										//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
										// Retorno da User Function CP01011: ³ 
										// TIPO: ARRAY UNIDIMENSIONAL	 	 ³
										// [1]: RETORNO LÓGICO 			(L)  ³
										// [2]: NOTA ORIGEM 			(C)  ³
										// [3]: SERIE ORIGEM			(C)  ³
										// [4]: ITEM ORIGEM				(C)  ³
										// [5]: ID DO PODER DE TERCEIRO (C)  ³
										// [5]: MENSAGEM DE RETORNO		(C)  ³
										//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ									
										IF ! EMPTY(aDanfeOrig[1])
											
											aRetPD3:= u_CP0101X( XFILIAL('SD1')	 , cProduto, cCliFor, cLoja , aDanfeOrig[1], aDanfeOrig[2] , nQtdePri, nVlrUni )											
										
											IF aRetPD3[1]
																														
												AADD(aLinhaNfe, {"D1_NFORI"		,aRetPD3[2]		,NIL})
												AADD(aLinhaNfe, {"D1_SERIORI"	,aRetPD3[3]		,NIL}) 
												AADD(aLinhaNfe, {"D1_ITEMORI"	,aRetPD3[4]		,NIL})
												AADD(aLinhaNfe, {"D1_IDENTB6"	,aRetPD3[5]		,NIL})
												IF EMPTY(cTES)
													
													//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
													//³ Verifica se a TES Gera - DUPLICATA ³
													//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
													DBSELECTAREA("SF4")
													SF4->(DBSETORDER(1))   //| F4_FILIAL, F4_CODIGO
									
													IF SF4->(DBSEEK(XFILIAL("SF4")+aRetPD3[7]))
														
														IF SF4->(DBSEEK(XFILIAL("SF4")+SF4->F4_TESDV)) // BUSCO TES DE DEVOLUÇÃO
															
															cTES := SF4->F4_CODIGO										
															AADD(aLinhaNfe, {"D1_TES"	,cTES	,NIL})			
															
															IF SF4->F4_DUPLIC == "S"
																lTitNFeAuto	:= .T.
															ENDIF
															
														ENDIF
														
													ENDIF
																																	
												ENDIF			
											
												aRet[2]	+= aRetPD3[6]+CRLF
											
											ELSE
												
												lClassifica	:= .F. 
												aRet[2] += aRetPD3[6]+CRLF
																	
																			
											ENDIF
										
										ELSE
												
												lClassifica	:= .F. 
												aRet[2] += "Este tipo de entrada deve-se vincular o poder de terceiro Verifique."+CRLF
										
										
										ENDIF
									ENDIF						
							
							
									//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
									//³ Verifica se a TES Gera - DUPLICATA ³
									//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
									IF lTitNFeAuto                                                                              
										
										AADD(aCabecNfe,{"F1_COND"	, ALLTRIM(U_CP01005G("11", "CPAGPADRAO"))	, nil })
										AADD(aCabecNfe,{"E2_NATUREZ", ALLTRIM(U_CP01005G("11", "NATPADRAO"))	, nil })
																				
									ENDIF																											
								ENDIF 
								
	
								
								IF !EMPTY(Z11->Z11_LOTECT) //.AND. !EMPTY(Z11->Z11_DTVALI)
									AADD(aLinhaNfe, {"D1_LOTEFOR"		,Z11->Z11_LOTEFO					,NIL})
									AADD(aLinhaNfe, {"D1_LOTECTL"		,Z11->Z11_LOTECT					,NIL})
									AADD(aLinhaNfe, {"D1_DTVALID"		,Z11->Z11_DTVALI					,NIL})
								ENDIF 
								
	
								
	
								//ÚÄÄÄÄÄÄÄÄÄÄ¿
								//³ IMPOSTOS ³
								//ÀÄÄÄÄÄÄÄÄÄÄÙ
								//ÚÄÄÄÄÄÄ¿
								//³ ICMS ³
								//ÀÄÄÄÄÄÄÙ
								IF Z11->Z11_ICVLR > 0
									AADD(aLinhaNfe, {"D1_BASEICM"	,Z11->Z11_ICBC	,NIL})
									AADD(aLinhaNfe, {"D1_PICM"		,Z11->Z11_ICALQ	,NIL})
									AADD(aLinhaNfe, {"D1_VALICM"	,Z11->Z11_ICVLR	,NIL})
								ENDIF    
								                
	
								//ÚÄÄÄÄÄ¿
								//³ IPI ³
								//ÀÄÄÄÄÄÙ
								IF Z11->Z11_IPIVLR > 0						
									AADD(aLinhaNfe, {"D1_BASEIPI"	,Z11->Z11_IPIBC 	,NIL})
									AADD(aLinhaNfe, {"D1_IPI"		,Z11->Z11_IPIALQ	,NIL})
									AADD(aLinhaNfe, {"D1_VALIPI"	,Z11->Z11_IPIVLR	,NIL})
								ENDIF 
								   
								AADD(aLinhaNfe, {"D1_XITEXML"		,Z11->Z11_ITEM		,NIL}) 
								AADD(aLinhaNfe, {"D1_XORIXML"		,Z11->Z11_ICORIG	,NIL}) // campo customizado origem Gomes da Costa
								cCFOPEXP	:= ALLTRIM( U_CP01005G("11", "CFOPEXP") )
	
								If !EMPTY(cCFOPEXP) 
									aCFOPEXP := U_cpC2A(cCFOPEXP, "/")								
								EndIf
								
								IF ASCAN( aCFOPEXP, RIGHT( alltrim(cCFOP),3) ) > 0 
									AADD(aLinhaNfe, {"D1_XEANTRB"	,Z11->Z11_EANTRB	,NIL})
									AADD(aLinhaNfe, {"D1_XUTRIB"	,Z11->Z11_UTRIB		,NIL})
									AADD(aLinhaNfe, {"D1_XQTRIB"	,Z11->Z11_QTRIB		,NIL})
									AADD(aLinhaNfe, {"D1_XVUNTIB"	,Z11->Z11_VUNTIB	,NIL})								
								ENDIF
														
								AADD(aPosIpi, Z11->Z11_POSIPI					) 	
							     /*                                                 
									//ÚÄÄÄÄÄÄÄÄ¿
									//³ COFINS ³
									//ÀÄÄÄÄÄÄÄÄÙ
									IF VALTYPE(XmlChildEx(oDet[nItem]:_IMPOSTO, "_COFINS")) == "O"				
										nNodeImp := XmlChildCount(oDet[nItem]:_IMPOSTO:_COFINS)
										
										FOR n := 1 TO nNodeImp
										                          
											oImposto := XmlGetchild(oDet[nItem]:_IMPOSTO:_COFINS, nImp)
											
											IF VALTYPE(XmlChildEx(oImposto, "_VCOFINS")) == "O"				
												AADD(aLinhaNfe, {""		,val(oImposto:_PCOFINS:TEXT)	,NIL})
												AADD(aLinhaNfe, {""	,val(oImposto:_VCOFINS:TEXT)	,NIL}) 
											ENDIF									
										NEXT nImp
									ENDIF  
									*/																
								
								aAdd(aItensNFe,aLinhaNfe)														
								
								Z11->(DBSKIP())
							ENDDO  
							
							
	
							RestArea(aAreaZ11)				        
							
							//alert("teste 1")
							
							/*------------------------------------------------------ Augusto Ribeiro | 18/02/2020 - 11:38:42 AM
								Notificao ao usuario antes de prosseguir
							------------------------------------------------------------------------------------------*/
							IF !empty(cAtencao) .and. !(ISBLIND())
								Aviso("Atenção", cAtencao,{"Fechar"},3,,,,.t.)
								cAtencao	:= ""
							ENDIF
							
							IF nNFxPC <> nItensNF
								aRecSC7	:= {}
							ENDIF
	
	
	
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ Sugere cadastro do Produto x Fornecedor ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							IF LEN(aProdFor) > 0
								IF lCadProFor .AND. !(lAuto)
							   		aRetPFor	:= {.T.,""}						   								   
							   		
	//						   		For nx := 1 to Len(aProdFor)
	//						   		
	////						   			ALERT("1-" + aProdFor[nx][1] )
	//									//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//									//³ Interface para cadastro do produto x fornecedor ³
	//									//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	//									nRecSA5		:= ProdFor( aProdFor[nx][1], SA2->A2_COD, SA2->A2_LOJA)								
	//	
	//									IF nRecSA5 == 0
	//								        aRetPFor	:= CadProdFor(aProdFor,  SA2->A2_COD, SA2->A2_LOJA)
	//								    ENDIF     
	//							    Next nX 
								    
								    aRetPFor	:= CadProdFor(aProdFor,  SA2->A2_COD, SA2->A2_LOJA)
								    //substiuída linha acima pela abaixo [Mauro Nagata, Compila, 20200212]
								    //aRetPFor	:= CadProdFor(aProdFor,  SA2->A2_COD, SA2->A2_LOJA, cPriUm)
								    
								    IF aRetPFor[1]
								    	For nx := 1 to Len(aProdFor)
											
											cProduto	:= U_CPGPfor( ALLTRIM(aProdFor[nx][1]), cCliFor, cLoja)[3]										
											IF !EMPTY(cProduto)
												lTryAgain := .T.	
												aRet[2]	:= ""  
											ENDIF
										Next nX 	
										 
										Z11->(DBSKIP())
										LOOP
									ELSE                     
										
										aRet[2]	:= "Cadastro Produto X Fornecedor: "+EOL+aRetPFor[2]
									ENDIF
								ENDIF
							ENDIF	
							
							
						ENDIF //| IFDEV Endif IF NF Devolucao|				
					ENDDO		

	
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Se todas as validações foram realizadas com sucesso ³
					//³ Gera Pre-Nota                                       ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					IF !lAbort  
					
					
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Verifica se a Nota Fiscal ja foi importada.              ³
						//³ 1. Consulta o numero da NF com 9 digisto                 ³
						//³ 2. Caso nao localizado, consulta novamente com 6 digitos ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						lExistSF1	:= .F.
						DBSELECTAREA("SF1")
						SF1->(DBSETORDER(8))	//| F1_FILIAL, F1_CHVNFE
						
						IF SF1->( DBSEEK(XFILIAL("SF1") + Z10->Z10_CHVNFE , .F.) )
							lExistSF1	:= .T.
						ELSE 
							SF1->(DBSETORDER(1))	//| F1_FILIAL, F1_DOC, F1_SERIE, F1_FORNECE, F1_LOJA, F1_TIPO
							
							IF SF1->( DBSEEK(XFILIAL("SF1") + Z10->Z10_NUMNFE + cSerie + cCliFor + cLoja + Z10->Z10_TIPNFE, .F.) )
								lExistSF1	:= .T.
							ELSE
								cNumNFe6	:= ALLTRIM(STR(VAL(Z10->Z10_NUMNFE)))
								
								IF LEN(cNumNFe6) <= 6                                 
									cNumNFe6	:= STRZERO(VAL(Z10->Z10_NUMNFE),6)
									cNumNFe6	:= PADR(cNumNFe6, TAMSX3("F1_DOC")[1]," ")
									
									IF SF1->( DBSEEK(XFILIAL("SF1") + cNumNFe6 + cSerie + cCliFor + cLoja + Z10->Z10_TIPNFE,.F.) )
										lExistSF1	:= .T.
									ENDIF
								ENDIF
							ENDIF 								
						ENDIF					
					    
					    SF1->(DBSETORDER(1))	//| F1_FILIAL, F1_DOC, F1_SERIE, F1_FORNECE, F1_LOJA, F1_TIPO
					        
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ NOTA FISCAL JA CADASTRADA                   ³
						//³ Tratamento para notas fiscais ja existentes ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						IF lExistSF1
							nD1COD 		:= Ascan(aItensNFe[1],{ |x| alltrim(x[1]) == "D1_COD" } )  
							nD1QUANT	:= Ascan(aItensNFe[1],{ |x| alltrim(x[1]) == "D1_QUANT" } )							
							nD1TOTAL	:= Ascan(aItensNFe[1],{ |x| alltrim(x[1]) == "D1_TOTAL" } )

							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ Agrupa produtos dos itens ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							aItemAgp := {}
							FOR nI := 1 TO LEN(aItensNFe)
								
								nPosAgp	:= Ascan(aItemAgp,{ |x| alltrim(x[1]) == ALLTRIM(aItensNFe[nI,nD1COD,2]) } ) 
								
								IF nPosAgp <= 0 
									AADD(aItemAgp, {aItensNFe[nI,nD1COD,2], aItensNFe[nI,nD1QUANT,2], aItensNFe[nI,nD1TOTAL,2]})
								ELSE
									aItemAgp[nPosAgp,2]	+= aItensNFe[nI,nD1QUANT,2]
									aItemAgp[nPosAgp,3]	+= aItensNFe[nI,nD1TOTAL,2]																	
								ENDIF
							NEXT nI  

							Asort(aItemAgp,,,{|x,y| y[1]})
						
							cQuery := " SELECT D1_COD, SUM(D1_QUANT) AS D1_QUANT, SUM(D1_TOTAL) AS D1_TOTAL "
							cQuery += " FROM "+RetSqlName("SD1")+" SD1 "
							cQuery += " WHERE D1_FILIAL = '"+SF1->F1_FILIAL+"' "
							cQuery += " 	AND D1_DOC = '"+SF1->F1_DOC+"' "
							cQuery += " 	AND D1_SERIE = '"+SF1->F1_SERIE+"' "
							cQuery += " 	AND D1_FORNECE = '"+SF1->F1_FORNECE+"' "
							cQuery += " 	AND D1_LOJA = '"+SF1->F1_LOJA+"' "
							cQuery += " 	AND D_E_L_E_T_ = '' "
							cQuery += " GROUP BY D1_COD"
							cQuery += " ORDER BY D1_COD"
							
							cQuery	:= ChangeQuery(cQuery)
							
							TcQuery cQuery New Alias "TSD1"	                  
							  
							nI := 0    
							cLogSF1	:= ""
							WHILE TSD1->(!EOF())
								nI++

						   		nPosAgp	:= Ascan(aItemAgp,{ |x| alltrim(x[1]) == alltrim(TSD1->D1_COD) } ) 
								
								IF nPosAgp > 0 
									IF aItemAgp[nPosAgp,2] <> TSD1->D1_QUANT
										cLogSF1	+= "Divergencia nas quantidades, Prod.:"+alltrim(TSD1->D1_COD)+;
													" Qtde. pre-nota:"+alltrim(transform(TSD1->D1_QUANT,PESQPICT("SD1","D1_QUANT")))+;
													" Qtde. XML:"+alltrim(transform(aItemAgp[nPosAgp,2],PESQPICT("SD1","D1_QUANT")))+EOL
									ELSEIF aItemAgp[nPosAgp,3] <> TSD1->D1_TOTAL
										cLogSF1	+= "Divergencia nos valores, Prod.:"+alltrim(TSD1->D1_COD)+;
													" Qtde. pre-nota:"+alltrim(transform(TSD1->D1_TOTAL,PESQPICT("SD1","D1_TOTAL")))+;
													" Qtde. XML:"+alltrim(transform(aItemAgp[nPosAgp,3],PESQPICT("SD1","D1_TOTAL")))+EOL
									ENDIF									
								ELSE  
									cLogSF1	+= "Produto da pre-nota/nota nao encontrato no XML:"+alltrim(TSD1->D1_COD)
								ENDIF
								
								TSD1->(DBSKIP())
							ENDDO	
							
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ Apos validacoes de quantidade e valor           ³
							//³ Amarra Chave da Danfe com Pre-Nota ja existente ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//							IF EMPTY(cLogSF1)		

								IF EMPTY(SF1->F1_CHVNFE)
									RECLOCK("SF1",.F.)
										SF1->F1_CHVNFE	:= cChvDanfe
									SF1->(MSUNLOCK())
								ENDIF
			
								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
								//³ Altera status da tabela intemediaria ³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
								IF Z10->Z10_STATUS <> '2'	// 1=Não Importado;2=Importado;3=Desconsiderado
									RECLOCK("Z10",.F.)
									//Z10->Z10_STATUS	:= "2"
									//substituída linha acima pela abaixo [Mauro Nagata, Compila, 20200211]
									//pré-nota = F1_STATUS = vazio
									Z10->Z10_STATUS	:= If(!Empty(SF1->F1_STATUS) .And. !SF1->F1_STATUS $ "C","5","2") //2, importado/gerado 5, classificado
									Z10->(MSUNLOCK())
								ENDIF	   
								
								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
								//³ Adiciona campo Observacoes a Nota Fiscal ³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
								IF !empty(cInfAdic)
								
									//nAux := TamSX3("F1_XNFOBS")[1]    
									dbselectarea("SYP")
									MSMM(,,,cInfAdic,1,,.T.,"SF1","F1_XCNFOBS")
								ENDIF								
								
								aRet[1]	:= .T.
								aRet[2]	:= "AVISO: Nota Fiscal já cadastrada "+SF1->(F1_DOC+" "+F1_SERIE)+EOL+cLogSF1							
								aRet[3]	:= SF1->(RECNO())

							
							TSD1->(DBCLOSEAREA())						
						ELSE
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ PONTO DE ENTRADA: CP0102OK                                ³
							//³                                                           ³
							//³ Apos as validacaoes padrao e Antes do Envio para Execauto ³
							//³ Arrays passados por referencia                            ³
							//³                                                           ³
							//³ Retorno: Logico                                           ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ     
							//IF EXISTBLOCK("CP0102OK")
							//substituída linha acima pelo abaixo [Mauro Nagata, Compila, 20200214]
							IF EXISTBLOCK("CP0102OK") .And. !(Z10->Z10_TIPNFE $ "B.D")
								//aGeraNota	:= Execblock("CP0102OK",.F.,.F.,{@aCabecNfe, @aItensNFe})							
								aAreaZ10	:= Z10->(GetArea())
							
								aGeraNota	:= U_CP0102OK(lAuto, @aCabecNfe, @aItensNFe,aPosIpi)
								
								RestArea(aAreaZ10)
								IF VALTYPE(aGeraNota) <> "A"
									aGeraNota	:= {.F., ""}
								ENDIF
							ELSE 
								aGeraNota	:= {.T., ""}
							ENDIF
						      
							IF aGeraNota[1]
							
								nDifUM	:= ROUND(nDifUM,nDVUNIT)
								IF nDifUM > 0
									CONOUT("####| Diferenca conversao UM: "+alltrim(str(nDifUM)) )
								ENDIF
								
								/*----------------------------------------
									06/06/2019 - Jonatas Oliveira - Compila
									Realiza validação se lote está preenchido
								------------------------------------------*/
								IF !lControL
									nD1COD 		:= Ascan(aItensNFe[1],{ |x| alltrim(x[1]) == "D1_COD" } ) 
									nD1LOT 		:= Ascan(aItensNFe[1],{ |x| alltrim(x[1]) == "D1_LOTECTL" } ) 
									nD1DTL 		:= Ascan(aItensNFe[1],{ |x| alltrim(x[1]) == "D1_DTVALID" } ) 
									
									lAbort := .F.
									For nW := 1 To Len(aItensNFe)
										IF SB1->(DBSEEK(XFILIAL("SB1") + aItensNFe[nW,nD1COD,2] )) .AND. SB1->B1_RASTRO == "L"	
											IF nD1LOT > 0 .AND. nD1DTL > 0 
												IF ( EMPTY(aItensNFe[nW,nD1LOT,2]) .OR. EMPTY(aItensNFe[nW,nD1DTL,2]) )											
													IF !lControL 
														lAbort := .T.
														aRet[1] := .F.								
														aRet[2]	+= "Produto com controle de lote. Necessário informar Lote e Validade: " + ALLTRIM(cProduto) +EOL
													ENDIF
												ENDIF
											ELSE
												IF !lControL 
													lAbort := .T.
													aRet[1] := .F.								
													aRet[2]	+= "Produto com controle de lote. Necessário informar Lote e Validade: " + ALLTRIM(cProduto) +EOL
												ENDIF 
											ENDIF
										ENDIF 
									Next nW
								ENDIF 
								
								IF !lAbort
									IF lDocEnt
										
										/*----------------------------------------
											06/06/2019 - Jonatas Oliveira - Compila
											Verifica se a TES Gera - DUPLICATA
										------------------------------------------*/
										IF lTitNFeAuto                                                                              
											
											AADD(aCabecNfe,{"F1_COND"	, ALLTRIM(U_CP01005G("11", "CPAGPADRAO")), nil })
											AADD(aCabecNfe,{"E2_NATUREZ", ALLTRIM(U_CP01005G("11", "NATPADRAO")), nil })
																					
										ENDIF
										
										BEGIN TRANSACTION
										
											lMSErroAuto := .F. 
										
											nOpc	:= 3 //| Inclusão
											MSExecAuto({|x,y,z|Mata103(x,y,z)},aCabecNfe,aItensNFe,nOpc)   
										
											If lMSErroAuto
												DisarmTransaction()
												//MostraErro()
										
												cErroExec	:= ""
												cPathLog	:=	NOMEAUTOLOG()
												IF !EMPTY(cPathLog)
													cErroExec	:=	STRTRAN(MemoRead(cPathLog),'"',"")
													
													cErroExec	:= U_cpReadError(cErroExec)
												ENDIF
												
												aRet[2]	:= "Falha na Geração da Pre-Nota "+CRLF+cErroExec+CRLF
											ELSE          
										
												//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
												//³ Pre-Nota Gravada com Sucesso ³
												//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
												aRet[1]	:= .T.
												aRet[2]	:= "Nota Fiscal Classificada com sucesso!"+CRLF
												
												//Tratamento para legenda caso classificação automatica - Thiago Nascimento - 22/01/14
												DBSELECTAREA("Z10")
												Z10->(DBSETORDER(1)) //| Z10_FILIAL, Z10_CHVNFE, Z10_TIPARQ
												IF Z10->(DBSEEK(XFILIAL("Z10")+SF1->F1_CHVNFE) )
												
													//Status 5, nota Classificada.
													Reclock("Z10", .F.)
														Z10->Z10_STATUS := "5"
													Z10->(MSUNLOCK())
													
												ENDIF
											ENDIF		     
											
										END TRANSACTION									
									ELSE
									      
										//BEGIN TRANSACTION
										
											lMSErroAuto := .F. 
											
							                C_TIPO_F1	:= Z10->Z10_TIPNFE
							                C_FORN_F1	:= cCliFor
							                C_LOJA_F1	:= cLoja
							                C_EST		:= cUFCliFor									
		
											MSExecAuto({|x,y,z| MATA140(x,y,z)}, aCabecNfe, aItensNFe, 3)
		
											If lMSErroAuto
										//		DisarmTransaction()
												//MostraErro()
						
												cErroExec	:= ""
												cPathLog	:=	NOMEAUTOLOG()
												IF !EMPTY(cPathLog)
													cErroExec	:=	STRTRAN(MemoRead(cPathLog),'"',"")
													
												  	cErroExec	:= U_cpReadError(cErroExec)
												ENDIF
												
												aRet[2]	:= "Falha na Geração da Pre-Nota "+EOL+cErroExec+EOL+aGeraNota[2]
											ELSE          
										
												//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
												//³ Pre-Nota Gravada com Sucesso ³
												//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
												aRet[1]	:= .T.
												aRet[2]	:= "Pré-Nota Gerada com sucesso."+EOL+aGeraNota[2]
												aRet[3]	:= SF1->(RECNO())										                   
												
												dbselectarea("SF1")                      
		
		//										RECLOCK("SF1",.F.)
		//											SF1->F1_CHVNFE	:= cChvDanfe
		//										SF1->(MSUNLOCK())
												
												//ÚÄÄÄÄÄÄÄÄÄÄÄ¿
												//³ Grava log ³
												//ÀÄÄÄÄÄÄÄÄÄÄÄÙ     
												dbselectarea("SYP")
												IF !EMPTY(aGeraNota[2]) 
													IF EMPTY(Z10->Z10_CODLOG)
														MSMM(,,,DTOC(DDATABASE)+"-"+TIME()+"|"+aRet[2],1,,.T.,"Z10","Z10_CODLOG")
													ELSE 
														MSMM(Z10->Z10_CODLOG,,,DTOC(DDATABASE)+"-"+TIME()+"|"+aRet[2],1,,.T.,"Z10","Z10_CODLOG")											
													ENDIF
												ELSEIF !EMPTY(Z10->Z10_CODLOG) .AND. EMPTY(aGeraNota[2])
													//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
													//³ Remove campo SYP caso exista dados  ³
													//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
													MSMM(Z10->Z10_CODLOG,,,,2,,,"Z10","Z10_CODLOG") 
												ENDIF									  
												
											  
												DBSELECTAREA("Z10")
												RECLOCK("Z10",.F.)
													Z10->Z10_STATUS	:= "2"	//gerada pre nota
												Z10->(MSUNLOCK())
												                                          
												//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
												//³ Adiciona campo Observacoes a Nota Fiscal ³
												//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
												IF !empty(cInfAdic)
												
													//nAux := TamSX3("F1_XNFOBS")[1]    
													/*
													dbselectarea("SYP")
													MSMM(,,,cInfAdic,1,,.T.,"SF1","F1_XCNFOBS")
													*/
												ENDIF								       
		
											ENDIF
											
										//END TRANSACTION  
									
									ENDIF 
								ENDIF 
							ELSE                      
								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
								//³ Repassa mensagem de erro do Ponto de Entrada para o Log ³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
								aRet[2]	+= aGeraNota[2]+EOL
							ENDIF                          
						ENDIF
					ENDIF
				ELSE    
					IF !(lUtilCli)
						aRet[2]	:= "AVISO: Fornecedor não cadastrado ou Bloqueado, CNPJ/CPF: "+Z10->Z10_CNPJ
					ENDIF
				ENDIF	
			ELSE
				aRet[2]	:= "Falha na Abertura do XML, erro: "+cErro
			ENDIF     
		ELSE      
                                                                            
			aRet[2]	:= "Danfe não pertence ao Empresa+Filial Corrente ou nao está autorizada a executar esta operação. Emp+Fil XML: "+SM0->(M0_CODFIL) //SM0->(M0_CODIGO+M0_CODFIL)
		ENDIF    
	ELSE
		aRet[2]	:= "Registro não encontrado (Z10)."
	ENDIF	
ENDIF   
  


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Grava Mensagem de Log ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
IF !(aRet[1])
	IF !empty(aRet[2])    
		dbselectarea("SYP")
		IF EMPTY(Z10->Z10_CODLOG)
			MSMM(,,,DTOC(DDATABASE)+"-"+TIME()+"|"+aRet[2],1,,.T.,"Z10","Z10_CODLOG")
		ELSE
			MSMM(Z10->Z10_CODLOG,,,DTOC(DDATABASE)+"-"+TIME()+"|"+aRet[2],1,,.T.,"Z10","Z10_CODLOG")		
		ENDIF
		//MSMM(,_nTam1,,_cTeste,1,,,"SA1","A1_CODTST")		
	ENDIF
ENDIF

RestArea(aAreaSF1)

Return(aRet)




/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ CP0102S  ºAutor  ³ Augusto Ribeiro	 º Data ³  04/12/2010 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Importa XML da Danfe para O Pedido de Venda                º±±
±±º          ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function CP0102S(lAuto,cChvDanfe)
Local aRet			:= {.F.,""}
Local aAreaSF1		:= SF1->(GetArea())
        
Local cPathDest		:= LOWER(ALLTRIM(U_CP01005G("12", "XMLOK"))) //| Path de destino dos arquivos
Local lCadCli		:= U_CP01005G("12", "CADCLI")
Local lProdCli		:= U_CP01005G("12", "PRODCLIFOR")//|Cadastro de Produto com base no XML
Local cFullPath		:= cPathDest        
                                         
Local nC6ITEM	:= TAMSX3("C6_ITEM")[1]
Local nDQUANT	:= TAMSX3("D2_QUANT")[2]
Local nDPRCVEN	:= TAMSX3("D2_PRCVEN")[2]
Local nDTOTAL	:= TAMSX3("D2_TOTAL")[2]

Local aCabecPV, aLinhaPV, aItensPV
Local nY, nItem, lAbort
Local cErroExec, cPathLog   
Local cNumNFe, cSerie, cNumNFe6
Local aProdFor		:= {}   
Local lAuto
Local cPriUM, cSegUM, nQtde, nAux, cCFOP, aChvIDTes 
Local nQtdePri, nQtdeSeg, nVlrUni, nVlrTot  
Local nD1COD, nD1QUANT, nD1TOTAL
Local nPosAgp, lSF1OK, cLogSF1, cTes

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Numero de casas decimais ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local nDifUM	:= 0   
Local cInfAdic	:= ""
Local cQuery	:= "" 
Local aItemAgp	:= {}
Local aConvUM	:= {}
Local lExistSF2	:= .F.   
Local nImp	:= 0	
Local oImposto 
Local aRetCli	:= {}
Local lExistCli	:= .F.
Local cEmpParam	:= ALLTRIM(U_CP01005G("12", "XMLEFIL"))
             
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis para controle do uso de Fornecedor ou Cliente ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local cTipoPV, cCliFor	:= "", cLoja := "", cUFCliFor := ""
Local lUtilFor	:= .F.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas no objeto XML ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local oXML, oDANFE, oEmitente, oIdent, oDestino, oTotal, oTransp, oDet
Local cParc	:= "A"
								
Private cAviso	:= ""
Private cErro	:= ""                                                                                   

Private aTitNf_S 	:= {}
Private lTitNFeAuto	:= .F. //| Variavel utilizada no P.E.   para gravação customizada dos titulos

Default lAuto	:= .F.


IF !EMPTY(cChvDanfe)
	
	DBSELECTAREA("Z10")
	Z10->(DBSETORDER(1))	//| Z10_FILIAL, Z10_CHVNFE, R_E_C_N_O_, D_E_L_E_T_
	IF Z10->(DBSEEK(XFILIAL("Z10")+cChvDanfe+"S",.F.))   
	
		IF Z10->Z10_TIPARQ <> "S"
			aRet[2]		:= "Arquivo não corresponde a uma nota fiscal de saida."
			Return(aRet)
		ENDIF
                                                  		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		//³ Valida Empresa e Filial ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		IF Z10->Z10_CODEMP == SM0->M0_CODIGO .AND. Z10->Z10_CODFIL == SM0->M0_CODFIL .AND.(EMPTY(cEmpParam) .OR. SM0->(M0_CODFIL)  $ cEmpParam)    //SM0->(M0_CODIGO+M0_CODFIL)

			cFullPath	+= ALLTRIM(Z10->Z10_ARQUIV)
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Transforma XML e OBJETO ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			oXML := XmlParserFile(cFullPath,"_",@cErro, @cAviso)
			IF VALTYPE(oXML) == "O" 		
			
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Divide objeto da XML para facilitar o Acesso aos dados ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				IF VALTYPE(XmlChildEx(oXML, "_NFEPROC")) == "O"     
					IF VALTYPE(XmlChildEx(oXML:_nfeproc, "_NFE")) == "O"
						oDANFE		:= oXML:_nfeproc:_NFe        
					ENDIF                                   
				ELSEIF VALTYPE(XmlChildEx(oXML, "_NFE")) == "O"
					oDANFE		:= oXML:_NFe
				ENDIF

				oEmitente	:= oDANFE:_InfNfe:_Emit
				oIdent		:= oDANFE:_InfNfe:_IDE
				oDestino	:= oDANFE:_InfNfe:_Dest
				oTotal		:= oDANFE:_InfNfe:_Total
				oTransp		:= oDANFE:_InfNfe:_Transp
				oDet		:= oDANFE:_InfNfe:_Det  
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Verifica se existe informacoes adicionais ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				IF !EMPTY(Z10->Z10_CODADD)
					cInfAdic	:= MSMM(Z10->Z10_CODADD)
				ENDIF
				         
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Tratamento necessario pois quando a Danfe possui somente     ³
				//³ um item, esta propriedade vem como objeto ao inves de array. ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				IF VALTYPE(oDet) == "O"
					oDet	:= {oDet}
				ENDIF
				      
				                                          
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Busca Cadastro de Clientes   ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				DbSelectArea("SA1")				
				aRetCli	:= RetCliFor("SA1",Z10->Z10_CNPJ, Z10->Z10_RAZAO)
				      
				IF LEN(aRetCli)	== 3
					SA1->(DBGOTO(aRetCli[3]))
					lExistCli	:= .T.
				ELSE
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Realiza o cadastro do Clientes manualmente   ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					IF lCadCli .AND. !(lAuto)
						CadCliente(oDestino)
						
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Busca Cadastro de Fornecedor ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						aRetCli	:= RetCliFor("SA1",Z10->Z10_CNPJ, Z10->Z10_RAZAO)
						IF LEN(aRetCli)	== 3
							SA2->(DBGOTO(aRetCli[3]))
							lExistCli	:= .T.
						ENDIF						

						IF  !lExistCli
							aRet[2]	+= " CPF/CNPJ "+Z10->Z10_CNPJ+" - Cliente Não encontrado."+EOL
						ENDIF 
					
					ENDIF
				ENDIF
				
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Busca Tipo da Nota com base no CFOP                    ³
				//³ Verifica se utiliza Fornecedor ou Cliente              ³
				//³ Independente da utilizacao de Cliente ou Fornecedor, e ³
				//³ obrigatoria a existencia do fornecedor em funcao da    ³
				//³ amarracao do cadastro de produto x fornecedor          ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				IF lExistCli .AND. (Z10->Z10_TIPNFE == "B" .or. Z10->Z10_TIPNFE == "D")
				
					lUtilFor	:= .T.									
					
					DBSELECTAREA("SA2")
					SA2->(DBSETORDER(3)) //| A2_FILIAL, A2_CGC
					IF SA2->(DBSEEK(XFILIAL("SA2")+ALLTRIM(oDestino:_CNPJ:TEXT),.F.))
					
						cCliFor 	:= SA2->A2_COD
						cLoja		:= SA2->A2_LOJA 
						cUFCliFor	:= SA2->A2_EST 
					ELSE
						aRet[2]	+= "NFe Tipo "+Z10->Z10_TIPNFE+" - Fornecedor Não encontrado."+EOL
						cCliFor		:= ""
						cLoja		:= ""
						cUFCliFor	:= ""
					ENDIF

				ELSEIF lExistCli 
					cCliFor 	:= SA1->A1_COD
					cLoja		:= SA1->A1_LOJA 
					cUFCliFor	:= SA1->A1_EST				
				ENDIF
                
				IF !EMPTY(cCliFor) .AND. (lExistCli .OR. lUtilFor)
					cSerie	:= Z10->Z10_SERIE
					cSerie	:= PADR(cSerie, TAMSX3("F2_SERIE")[1]," ")
					


					//ÚÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ CABECALHO ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÙ
					aCabecPV	:= {}
					AADD(aCabecPV, {"C5_FILIAL"	,	XFILIAL('SC5')	,NIL}) 
					AADD(aCabecPV, {"C5_TIPO", 		Z10->Z10_TIPNFE	,NIL}) 
					AADD(aCabecPV, {"C5_CLIENTE", 	cCliFor			,NIL}) 
					AADD(aCabecPV, {"C5_LOJACLI", 	cLoja			,NIL}) 
					AADD(aCabecPV, {"C5_CLIENT", 	cCliFor			,NIL}) 
					AADD(aCabecPV, {"C5_LOJAENT", 	cLoja			,NIL}) 					
//					AADD(aCabecPV, {"C5_TIPOCLI",	"F"				,NIL}) 
//					AADD(aCabecPV, {"C5_CONDPAG",	"001"			,NIL}) //| ###
					AADD(aCabecPV, {"C5_MENNOTA",	cInfAdic		,NIL}) 	

					AADD(aCabecPV, {"C5_FRETE",		0		,NIL})
					AADD(aCabecPV, {"C5_DESPESA",	0		,NIL})
					AADD(aCabecPV, {"C5_SEGURO",	0		,NIL})
					AADD(aCabecPV, {"C5_FRETAUT",	0		,NIL})

					         
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Cria Variaveis com a posicao do Array de cada campo do cabecalho ³
					//³ Exemplo: F1_DOC = nF1DOC | F1_SERIE = nF1SERIE                  ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ			
					FOR nY := 1 TO LEN(aCabecPV)
						&("n"+REPLACE(aCabecPV[nY, 1],"_",""))	:= nY
					NEXT nY	    
					
					DBSELECTAREA("Z11") 
					Z11->(DBSETORDER(1))	//| Z11_FILIAL, Z11_CHVNFE, Z11_ITEM

					Z11->(DBSEEK(Z10->(Z10_FILIAL+Z10_CHVNFE+Z10_TIPARQ)))
					aAreaZ11	:= Z11->(GetArea())						

					aItensPV	:= {}
					nItem	:= 0
					WHILE Z11->(!EOF()) .AND. Z11->(Z11_FILIAL+Z11_CHVNFE+Z11_TIPARQ) == Z10->(Z10_FILIAL+Z10_CHVNFE+Z10_TIPARQ)
						aLinhaPV	:= {}   
						cProduto	:= ""   
						        
						nQtdePri	:= 0
						nQtdeSeg	:= 0
						nVlrUni		:= 0
						nVlrTot		:= 0
						
						cPriUM		:= ""
						cSegUM		:= ""

						nItem++						

						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Verifica se unidade de medida existe  ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
      					cPriUM		:= ALLTRIM(upper(Z11->Z11_UM))
                        //| Remove caracteres especiais.
                        cPriUM		:= RemovChar(cPriUM)
						
						DBSELECTAREA("SAH")
						SAH->(DBSETORDER(1))
						IF !(SAH->(DBSEEK(XFILIAL("SAH")+cPriUM,.F.))) .OR. LEN(cPriUM) > TAMSX3("AH_UNIMED")[1]
						
							DBSELECTAREA("Z09")
							Z09->(DBSETORDER(1))
							IF !(Z09->(DBSEEK(XFILIAL("Z09")+cPriUM,.F.)) .AND. ALLTRIM(Z09->Z09_UMDE) == ALLTRIM(cPriUM))
								aRet[2]	+= "Unidade de Medida Inválida: "+cPriUM+" [4]"+EOL
								lAbort	:= .T.
							ENDIF
						ENDIF							
					
						nQtdePri	:= Z11->Z11_QUANT      
						nVlrUni		:= Z11->Z11_VLRUNI	 
						nVlrTot		:= Z11->Z11_VLRTOT
						    
						nQtdePri	:= Round(nQtdePri,nDQUANT) 
						nVlrUni		:= Round(nVlrUni,nDPRCVEN) 
						nVlrTot		:= Round(nVlrTot,nDTOTAL) 	  
						
						    
						IF lProdCli//|Grava Produto com base no XML
						 	cProduto := "1"+cCliFor+cLoja+PADR(Z11->Z11_CODPRO,TAMSX3("B1_COD")[1]-9)
						ELSE
							cProduto := alltrim(Z11->Z11_CODPRO)//ALLTRIM(oDet[nItem]:_Prod:_xProd:TEXT)						
						ENDIF 

						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Posiciona Cadastro de Produto³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						DBSELECTAREA("SB1")
						SB1->(DBSETORDER(1))
						IF SB1->(!DBSEEK(XFILIAL("SB1")+cProduto,.F.))
						
							/*Gera EXECAUTO do cadastro de Produto*/
							aDadosCad :=  {}
		
							aadd(aDadosCad, {"B1_COD"	 ,cProduto					,Nil})
							aadd(aDadosCad, {"B1_DESC"   ,ALLTRIM(Z11->Z11_DESPRO)	,Nil})
							aadd(aDadosCad, {"B1_UM"     ,ALLTRIM(Z11->Z11_UM)		,Nil})
							aadd(aDadosCad, {"B1_IPI"    ,Z11->Z11_IPIALQ			,Nil})
							aadd(aDadosCad, {"B1_POSIPI" ,ALLTRIM(Z11->Z11_POSIPI)	,Nil})
							aadd(aDadosCad, {"B1_SEGUM"  ,ALLTRIM(Z11->Z11_UM)		,Nil})
							aadd(aDadosCad, {"B1_LOCPAD" ,'01'						,Nil})
							aadd(aDadosCad, {"B1_IRRF"   ,'N'						,Nil})   
							aadd(aDadosCad, {"B1_ORIGEM" ,ALLTRIM(Z11->Z11_ICORIG)	,Nil})  //Alterado por Eduardo Felipe em 18/06/14 - Adicionar a Origem do produto
							
							lMsErroAuto := .F.
							lMSHelpAuto := .F.
							lAutoErrNoFile := .T.
							
							//Chama rotina automatica do cadastro de produto
							MSExecAuto({|x,y| Mata010(x,y)},aDadosCad,3)
							
							/*Caso ocorra erro no EXECAUTO Apresenta Interface para cadastro*/
							IF lMsErroAuto
								
								cAliasImp	:= "SB1"
								cFuncao		:= "MATA010"	//| Cadastro de Produtos
								cTituloImp	:= "Cadastro de Produtos"
								aDadosCad	:= {} //estrutura do array {{"B1_DESC", "MAX FOREVER", Nil}}
								
								aadd(aDadosCad, {"B1_COD"	 ,cProduto					,Nil})
								aadd(aDadosCad, {"B1_DESC"   ,ALLTRIM(Z11->Z11_DESPRO)	,Nil})
								aadd(aDadosCad, {"B1_UM"     ,ALLTRIM(Z11->Z11_UM)		,Nil})
								aadd(aDadosCad, {"B1_IPI"    ,Z11->Z11_IPIALQ			,Nil})
								aadd(aDadosCad, {"B1_POSIPI" ,ALLTRIM(Z11->Z11_POSIPI)	,Nil})
								aadd(aDadosCad, {"B1_SEGUM"  ,ALLTRIM(Z11->Z11_UM)		,Nil})
								aadd(aDadosCad, {"B1_LOCPAD" ,'01'						,Nil})
								aadd(aDadosCad, {"B1_IRRF"   ,'N'						,Nil})
								aadd(aDadosCad, {"B1_ORIGEM" ,ALLTRIM(Z11->Z11_ICORIG)	,Nil})  //Alterado por Eduardo Felipe em 18/06/14 - Adicionar a Origem do produto
								
								lAbortProd := U_cpGrvCad(cAliasImp, cTituloImp, cFuncao, aDadosCad)
							ENDIF							
						ENDIF
				

						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Posiciona Cadastro de Produto³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						DBSELECTAREA("SB1")
						SB1->(DBSETORDER(1))
						IF SB1->(DBSEEK(XFILIAL("SB1")+cProduto,.F.))
							
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ Compara unidade de medida com cadastro de produto e ³
							//³ Realiza tratamentos se necessario                   ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							IF cPriUM == SB1->B1_UM
								cSegUM	:= ""
	
							ELSEIF cPriUM == SB1->B1_SEGUM
	
								cSegUM		:= cPriUM
								nQtdeSeg	:= nQtdePri
								                
								IF EMPTY(SB1->B1_TIPCONV) .OR. EMPTY(SB1->B1_CONV)
									aRet[2]	+= "Unidade de Medida Inválida: "+cPriUM+" - "+ALLTRIM(cProduto)+" | Tipo de conversao/Fator não informado"+" [5]"+EOL
									lAbort	:= .T.
								ENDIF
								
																                
								IF SB1->B1_TIPCONV == "M"
	
									nQtdePri	:= round(nQtdeSeg/SB1->B1_CONV, nDQUANT)
									nVlrUni		:= Round(nVlrUni*SB1->B1_CONV,nDPRCVEN)
	
								ELSEIF SB1->B1_TIPCONV == "D"
								
									nQtdePri	:= nQtdeSeg*SB1->B1_CONV             
									nVlrUni		:= Round(nVlrUni/SB1->B1_CONV,nDPRCVEN)
								ENDIF                                                           
								                  
								                  
								IF nQtdePri*nVlrUni  == nVlrTot
									nVlrTot		:= nQtdePri*nVlrUni
								ELSE
									//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
									//³ Acumula diferencas ³
									//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
									nDifUM		+= (nQtdePri*nVlrUni)-nVlrTot
									
									nVlrTot		:= nQtdePri*nVlrUni
								ENDIF								
							ELSE           
								
								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
								//³ Realiza a conversao da Unidade de Medida de acordo com a ³
								//³ tabela de conversoes                                     ³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
								aConvUM		:= U_CP01003A(cPriUM, SB1->B1_UM, nQtdePri, nVlrUni)
	
								IF aConvUM[1] > 0
	
									nQtdePri	:= Round(aConvUM[1],nDQUANT)									
									nVlrUni		:= Round(aConvUM[2],nDPRCVEN) 
									
									IF nQtdePri*nVlrUni  == nVlrTot
										nVlrTot		:= nQtdePri*nVlrUni
									ELSE
										//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
										//³ Acumula diferencas ³
										//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
										nDifUM		+= nVlrTot-(nQtdePri*nVlrUni)
										
										nVlrTot		:= nQtdePri*nVlrUni
									ENDIF									
								ELSE
									aRet[2]	+= "Unidade de Medida Inválida: "+cPriUM+" - "+ALLTRIM(cProduto)+" [6]"+EOL
									lAbort	:= .T.
								ENDIF								
							ENDIF													
														
	
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ Converte CFOP de Saida para Entrada ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							cCFOP	:= ALLTRIM(Z11->Z11_CFOP)
							cCFOP	:= U_CP0102CF(cCFOP)
																
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ Monta linha ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						   	AADD(aLinhaPV, {"C6_FILIAL"	,XFILIAL('SC6')		  			,NIL}) 
						   	AADD(aLinhaPV, {"C6_ITEM"	,STRZERO(nItem,nC6ITEM)	  			,NIL}) 						   	
							
							AADD(aLinhaPV, {"C6_PRODUTO" 		,cProduto	,NIL})   
							AADD(aLinhaPV, {"C6_CLI", 	cCliFor			,NIL}) 
							AADD(aLinhaPV, {"C6_LOJA", 	cLoja			,NIL}) 
							
							IF !EMPTY(cSegUM)
								AADD(aLinhaPV, {"C6_UNSVEN"	,nQtdeSeg					,NIL}) 
							ENDIF                                                             
							
							AADD(aLinhaPV, {"C6_QTDVEN"		,nQtdePri					,NIL})
							AADD(aLinhaPV, {"C6_PRCVEN"		,nVlrUni					,NIL}) 
//							AADD(aLinhaPV, {"C6_VALOR"		,nVlrTot					,NIL})
							AADD(aLinhaPV, {"C6_QTDLIB"		,nQtdePri					,NIL})
							                                                                                  
							aChvIDTes	:= {cCliFor+cLoja,cProduto}  
							cTes		:= U_CP01009T("S", , aChvIDTes)
							AADD(aLinhaPV, {"C6_TES"		, cTes	,NIL})
							
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ Verifica se a TES Gera - DUPLICATA ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							DBSELECTAREA("SF4")
							SF4->(DBSETORDER(1))   //| F4_FILIAL, F4_CODIGO
		
							IF SF4->(DBSEEK(XFILIAL("SF4")+cTES))
								IF SF4->F4_DUPLIC == "S"
									lTitNFeAuto	:= .T.
								ENDIF
							ENDIF                           
	                         
							aadd(aItensPV,aLinhaPV)                              
						ELSE
							aRet[2]	+= "Produto não encontrado: "+cProduto+" "+cProduto+EOL
							lAbort	:= .T.
						ENDIF 							
						Z11->(DBSKIP())
					ENDDO             
					RestArea(aAreaZ11)					
					


					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Se todas as validações foram realizadas com sucesso ³
					//³ Gera Pre-Nota                                       ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					IF !lAbort   
					     
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Verifica se a TES Gera - DUPLICATA ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ					
						IF lTitNFeAuto                                  
							
							DBSELECTAREA("Z13")
							Z13->(DBSETORDER(1))
							
							IF Z13->(DBSEEK(XFILIAL("Z13")+Z10->Z10_CHVNFE+"S")) 
							
								
								
								aTitNf_S := {}
								cParc	:= "A"
								WHILE Z13->(!EOF()) .AND.  Z13->Z13_CHVNFE == Z10->Z10_CHVNFE .AND. Z13->Z13_TIPARQ == "S"
								   	
								   	aadd(aTitNf_S, {cParc, Z13->Z13_DTVENC, Z13->Z13_VALOR})
								   	
								   	cParc := SOMA1(cParc)						   			
									Z13->(DBSKIP())
								ENDDO
								
								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
								//³ Caso numero de titulos seja Menor ou Igual a 4, utiliza campos      ³
								//³padroes do Pedido de Venda, caso contrario, utiliza ponto de entrada ³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
								IF LEN(aTitNf_S) <= 4
								
									cCondPag	:= U_CP01005G("12", "CPAGTIPO9")								         
									lTitNFeAuto	:= .F.

									AADD(aCabecPV, {"C5_PARC1", aTitNf_S[1, 3]	,NIL})
									AADD(aCabecPV, {"C5_DATA1", aTitNf_S[1, 2]	,NIL})

									IF LEN(aTitNf_S) >= 2
										AADD(aCabecPV, {"C5_PARC2", aTitNf_S[2, 3]	,NIL})
										AADD(aCabecPV, {"C5_DATA2", aTitNf_S[2, 2]	,NIL})
										
										IF LEN(aTitNf_S) >= 3
											AADD(aCabecPV, {"C5_PARC3", aTitNf_S[3, 3]	,NIL})
											AADD(aCabecPV, {"C5_DATA3", aTitNf_S[3, 2]	,NIL})
											
											IF LEN(aTitNf_S) >= 4
												AADD(aCabecPV, {"C5_PARC4", aTitNf_S[4, 3]	,NIL})
												AADD(aCabecPV, {"C5_DATA4", aTitNf_S[5, 2]	,NIL})
											ENDIF											
										ENDIF														
									ENDIF								
								ELSE
									cCondPag	:= U_CP01005G("12", "CPAGPADRAO")
								ENDIF
							ELSE
								cCondPag	:= U_CP01005G("12", "CPAGPADRAO")
							ENDIF
						ELSE          
							cCondPag	:= U_CP01005G("12", "CPAGPADRAO")
						ENDIF
											 
						AADD(aCabecPV, {"C5_CONDPAG",	cCondPag,NIL})													           

					
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Verifica se a Nota Fiscal ja foi importada.              ³
						//³ 1. Consulta o numero da NF com 9 digisto                 ³
						//³ 2. Caso nao localizado, consulta novamente com 6 digitos ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						lExistSF2	:= .F.
						DBSELECTAREA("SF2") 
						SF2->(DBSETORDER(1))	///| F2_FILIAL, F2_DOC, F2_SERIE, F2_CLIENTE, F2_LOJA, F2_FORMUL, F2_TIPO
						IF SF1->( DBSEEK(XFILIAL("SF1")+Z10->Z10_NUMNFE+cSerie+cCliFor+cLoja,.F.) )
							lExistSF2	:= .T.
						ELSE
							cNumNFe6	:= ALLTRIM(STR(VAL(Z10->Z10_NUMNFE)))
							
							IF LEN(cNumNFe6) <= 6                                 
								cNumNFe6	:= STRZERO(VAL(Z10->Z10_NUMNFE),6)
								cNumNFe6	:= PADR(cNumNFe6, TAMSX3("F2_DOC")[1]," ")
								
								IF SF1->( DBSEEK(XFILIAL("SF2")+cNumNFe6+cSerie+cCliFor+cLoja,.F.) )
									lExistSF2	:= .T.
								ENDIF
							ENDIF
						ENDIF					
					        	
					        	

						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ NOTA FISCAL JA CADASTRADA                   ³
						//³ Tratamento para notas fiscais ja existentes ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						IF lExistSF2    
							DBSELECTAREA("SC5")
							SC5->(DBSETORDER(1)) 

							DBSELECTAREA("SD2")
							SD2->(DBSETORDER(1)) //| D2_FILIAL, D2_DOC, D2_SERIE, D2_CLIENTE, D2_LOJA
							
							IF SD2->(DBSEEK(SF2->(F2_FILIAL+F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA),.F.))
								
								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
								//³ Grava chave da Danfe no Pedido ³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
								WHILE SD2->(!EOF()) .AND. SF2->(F2_FILIAL+F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA) == SD2->(D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA)
								
//									IF SC5->(DBSEEK(SD2->(D2_FILIAL+D2_PEDIDO+D2_ITEMPV) ))
									IF SC5->(DBSEEK(SD2->(D2_FILIAL+D2_PEDIDO) ))
										IF EMPTY(SC5->C5_XCHVNFE)
											RECLOCK("SC5",.F.)
												SC5->C5_XCHVNFE := cChvDanfe
											MSUNLOCK()
										ENDIF
									ENDIF
								     
									SD2->(DBSKIP())
								ENDDO						
							ENDIF
							
							aRet[1]	:= .T.
							aRet[2]	:= "AVISO: Nota Fiscal já cadastrada"
						ELSE 

							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³                      ³
							//³ GERA PEDIDO DE VENDA ³
							//³                      ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							nDifUM	:= ROUND(nDifUM,nDPRCVEN)
							IF nDifUM > 0
								CONOUT("####| Diferenca conversao UM: "+alltrim(str(nDifUM)) )
							ENDIF
							      
							BEGIN TRANSACTION
							
								lMSErroAuto := .F. 

								MSExecAuto({|x,y,z| MATA410(x,y,z)}, aCabecPV, aItensPV, 3)

								If lMSErroAuto
									DisarmTransaction()
									//MostraErro()
			
									cErroExec	:= ""
									cPathLog	:=	NOMEAUTOLOG()
									IF !EMPTY(cPathLog)
										cErroExec	:=	STRTRAN(MemoRead(cPathLog),'"',"")
										
									  	cErroExec	:= U_cpReadError(cErroExec)
									ENDIF
									
									aRet[2]	:= "Falha na Geração do Pedido de Venda "+EOL+cErroExec
								ELSE          
							
									//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
									//³ Pre-Nota Gravada com Sucesso ³
									//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
									aRet[1]	:= .T.
									aRet[2]	:= "Pedido de Venda com sucesso."+EOL
									                   
									dbselectarea("SC5")

									RECLOCK("SC5",.F.)
										SC5->C5_XCHVNFE	:= cChvDanfe
									SC5->(MSUNLOCK())
									
									//ÚÄÄÄÄÄÄÄÄÄÄÄ¿
									//³ Grava log ³
									//ÀÄÄÄÄÄÄÄÄÄÄÄÙ     
									dbselectarea("SYP")
									IF !EMPTY(aRet[2]) 
										IF EMPTY(Z10->Z10_CODLOG)
											MSMM(,,,DTOC(DDATABASE)+"-"+TIME()+"|"+aRet[2],1,,.T.,"Z10","Z10_CODLOG")
										ELSE 
											MSMM(Z10->Z10_CODLOG,,,DTOC(DDATABASE)+"-"+TIME()+"|"+aRet[2],1,,.T.,"Z10","Z10_CODLOG")											
										ENDIF
									ELSEIF !EMPTY(Z10->Z10_CODLOG) .AND. EMPTY(aRet[2])
										//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
										//³ Remove campo SYP caso exista dados  ³
										//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
										MSMM(Z10->Z10_CODLOG,,,,2,,,"Z10","Z10_CODLOG") 
									ENDIF									  
									
								  
									DBSELECTAREA("Z10")
									RECLOCK("Z10",.F.)         
										Z10->Z10_STATUS	:= "2" 
										Z10->Z10_NUMPV	:= SC5->C5_NUM
									Z10->(MSUNLOCK())
									                                          

								ENDIF
								
							END TRANSACTION  						
						
						ENDIF
					ENDIF
				ENDIF
			ELSE
				aRet[2]	:= "Falha na Abertura do XML, erro: "+cErro
			ENDIF     
		ELSE      
                                                                            
			aRet[2]	:= "Danfe não pertence ao Empresa+Filial Corrente ou nao está autorizada a executar esta operação. Emp+Fil XML: "+SM0->(+M0_CODFIL)//SM0->(M0_CODIGO+M0_CODFIL)
		ENDIF    
	ELSE
		aRet[2]	:= "Registro não encontrado (Z10)."
	ENDIF	
ENDIF   
  


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Grava Mensagem de Log ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
IF !(aRet[1])
	IF !empty(aRet[2])    
		dbselectarea("SYP")
		MSMM(,,,DTOC(DDATABASE)+"-"+TIME()+"|"+aRet[2],1,,.T.,"Z10","Z10_CODLOG")
	ENDIF
ENDIF

RestArea(aAreaSF1)

Return(aRet)




/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ ProdFor  ºAutor  ³ Augusto Ribeiro	 º Data ³  24/04/2010 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Retorna Recno do SA5 posicionado no Produto correto        º±±
±±º          ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function ProdFor(cProdFor, cCodFor, cLojaFor)
Local nRet 	:= 0
Local cQuery := ""

	cQuery := " SELECT R_E_C_N_O_  AS SA5_RECNO"
	cQuery += " FROM "+RetSQLName("SA5")+" SA5 "
	cQuery += " WHERE A5_FILIAL = '"+xfilial("SA5")+"' "
	cQuery += " AND A5_CODPRF = '"+alltrim(cProdFor)+"' "
	cQuery += " AND A5_FORNECE = '"+cCodFor+"' "
	cQuery += " AND A5_LOJA = '"+cLojaFor+"' "
	cQuery += " AND SA5.D_E_L_E_T_ = '' " 
	cQuery += " ORDER BY R_E_C_N_O_ "
	
	MemoWrite(GetTempPath(.T.) + "ProdFor"+ STRTRAN(TIME(),":","") +".SQL", cQuery) 

	cQuery	:= ChangeQuery(cQuery)
	
	TcQuery cQuery New Alias "TSA5"	                  
	
	IF TSA5->(!EOF())
		nRet	:= TSA5->SA5_RECNO
	ENDIF	
	
	TSA5->(DBCLOSEAREA())      
Return(nRet)



/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ CadProdForºAutor ³ Augusto Ribeiro	 º Data ³  16/12/2010 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Interface para auxilo do cadastro produto x fornecedor     º±±
±±º          ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function CadProdFor(aProdFor, cCodFor, cLoja)
//substituída linha acima pela abaixo [Mauro Nagata, Compila, 20200212]
//Static Function CadProdFor(aProdFor, cCodFor, cLoja, cPriUm)
//USER Function CadProdFor(aProdFor)
Local aRet		:= {.F.,""}
Local aProdFor                              
Local aSize, aObjects, aInfo, aPosObj
Local oFLabels 	:= TFont():New("MS Sans Serif",,026,,.F.,,,,,.F.,.T.)
                             
Local aButtons	:= {}
Local bOK		:= {|| processa({|| aRet	:= U_CPGRPFor(aCols, cCodFor, cLoja)}), oDlgCadFor:End()  }
Local bCanc		:= {|| oDlgCadFor:End()}

Local aCpoAlter	:= {"A5_PRODUTO","A5_FABR", "A5_FALOJA"}
//Local aCampos	:= {"A5_PRODUTO", "A5_NOMPROD", "A5_CODPRF", "A5_FABR", "A5_FALOJA","B1_DESC"}
//substituída linha acima pela abaixo [Mauro Nagata, Compila, 20200212]
//Local aCampos	:= {"A5_PRODUTO", "A5_NOMPROD", "B1_UM", "A5_CODPRF", "A5_FABR", "A5_FALOJA","B1_DESC"}
//substituído bloco acima pelo abaixo [Mauro Nagata, Compila, 20200308]
Local aCampos	:= {"A5_PRODUTO", "A5_NOMPROD", "B1_UM", "A5_CODPRF","Z11_DESPRO","Z11_UM", "A5_FABR", "A5_FALOJA"}
                                            
Local cTitulo	:= "Cadastro de Produto X Fornecedor"

Private oDlgCadFor
Private aHeader	:= {}
Private aCols	:= {}
Private bCampo	:= {|x| FieldName(x) }
Private aTela[0][0]
Private aGets[0]
  
Private oGetSA5                 
			
DBSELECTAREA("SA2")
SA2->(DBSETORDER(1))
SA2->(DBSEEK(XFILIAL("SA2")+cCodFor+cLoja))   

CONOUT("####| CadProdFor Fornecedor: "+cCodFor+"Loja"+ cLoja)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Dimensionamento da Janela - Parte Superior ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aSize 		:= MsAdvSize()		
aObjects	 := {}
 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Caso chamada da funcao tenha sito feita pelo botao consultar log ³
//³ Redimenciona tela para melhor visualizacao                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aAdd( aObjects, {100,100, .T., .T.} )	

aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ]*0.60, aSize[ 4 ]*0.55, 3, 3 }
aPosObj 	:= MsObjSize( aInfo, aObjects, .T. )                                                                         

aPosObj[1,1] += 12  

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta Dialog ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DEFINE MSDIALOG oDlgCadFor TITLE cTitulo FROM aSize[7],00 to aSize[6]*0.60,aSize[5]*0.60 OF oMainWnd PIXEL		

@ aPosObj[1,1]-12, aPosObj[1,2] SAY oLblSolicita PROMPT SA2->(A2_COD+" - "+A2_LOJA+":" + LEFT( A2_NOME , 10)) SIZE 131, 014 OF oDlgCadFor FONT oFLabels COLORS 128, 16777215 PIXEL

//ÚÄÄÄÄÄÄÄÄ¿
//³ BOTOES ³
//ÀÄÄÄÄÄÄÄÄÙ
//oSCVisual		:= TButton():New(aPosObj[1,1]-12, aPosObj[1,4]-150,"Gravar",oDlg,		{|| },045,010,,,,.T.,,"Gravar",,,,.F. )
                        
          
          
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Monta aHeader e aCols      	 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
MontaGet("SA5",@aHeader,@aCols, aCampos, aProdFor)
//substituída linha acima pela abaixo [Mauro Nagata, Compila, 20200212]
//MontaGet("SA5",@aHeader,@aCols, aCampos, aProdFor,cPriUm) 
 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Monta a GetDados.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
RegTomemory("SA5",.T.)
nOpc	:= 3
//MsGetDados():New( nTop, nLeft, nBottom, nRight, nOpc, [cLinhaOk], [cTudoOk], [cIniCpos], [lDelete], [aAlter], [uPar1], [lEmpty], [nMax], [cFieldOk], [cSuperDel], [uPar2], [cDelOk], [oWnd])
//oGetSA5 := MSGetDados():New(aPosObj[1,1],aPosObj[1,2],aPosObj[1,3],aPosObj[1,4],nOpc,"AllwaysTrue","AllwaysTrue","",.F., aCpoAlter,,,len(aCols)")
oGetSA5 := MSGetDados():New(aPosObj[1,1],aPosObj[1,2],aPosObj[1,3],aPosObj[1,4],nOpc,"AllwaysTrue","AllwaysTrue","",.F., aCpoAlter,,,len(aCols),"U_CP002FOK()")

oGetSA5:nOpc	:= 3        

ACTIVATE MSDIALOG oDlgCadFor CENTERED  ON INIT Eval({ || EnChoiceBar(oDlgCadFor,bOK,bCanc,.F.,aButtons) })

Return(aRet)


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MontaGet ºAutor  ³ Augusto Ribeiro	 º Data ³  16/12/2010 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Monta a Header e aCols vazio                               º±±
±±º          ³                                                            º±±
±±º          ³ aHeader = Passar por referencia                            º±±
±±º          ³ aCols   = Passar por referencia                            º±±
±±º          ³ aCampos = Campos a serem listados                          º±±
±±º          ³ aProdFor = Cod Produto Fornecedor                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function MontaGet(cAliasGet,aHeadGet, aColsGet, aCampos, aProdFor)
//substituída linha acima pela abaixo [Mauro Nagata, Compila, 20200212]
//Static Function MontaGet(cAliasGet,aHeadGet, aColsGet, aCampos, aProdFor, cPriUm)
Local nUsado	:= 0	
Local nY, nI   
Local nMaxCodprf	:= 0
Default aCampos	:= {}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta o aHeader.        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

aHeadGet := {}
aColsGet   := {}

DBSelectArea("SX3")
SX3->(DBSetOrder(2))
//SX3->(DBSeek(cAliasGet,.T.))

//While (SX3->(!Eof()) .And. SX3->X3_ARQUIVO == cAliasGet )

FOR nI := 1 to LEN(aProdFor)   
	IF LEN(ALLTRIM(aProdFor[nI, 1])) > nMaxCodprf
		nMaxCodprf	:= LEN(ALLTRIM(aProdFor[nI, 1]))
	ENDIF
Next nI

FOR nI := 1 TO Len(aCampos)


	IF SX3->(DBSeek(aCampos[nI],.F.))	
		If 	X3USO(SX3->X3_USADO) 		.And. ;
			cNivel >= SX3->X3_NIVEL	
			
			nUsado++
			
			/*         
			IF ALLTRIM(SX3->X3_CAMPO) == "A5_CODPRF"
				aAdd(aHeadGet,{ 	AllTrim(X3Titulo()),;
									SX3->X3_CAMPO,;
									SX3->X3_PICTURE,;
									nMaxCodprf,;
									SX3->X3_DECIMAL,;
									SX3->X3_VALID,;
									SX3->X3_USADO,;
									SX3->X3_TIPO,;
									SX3->X3_F3,;
									SX3->X3_CONTEXT } )
			ELSE
			*/
			If AllTrim(SX3->X3_CAMPO) == "A5_PRODUTO"
				aAdd(aHeadGet,{ 	"Produto",;
									SX3->X3_CAMPO,;
									"@S10" /*SX3->X3_PICTURE*/,;
									SX3->X3_TAMANHO,;
									SX3->X3_DECIMAL,;
									SX3->X3_VALID,;
									SX3->X3_USADO,;
									SX3->X3_TIPO,;
									SX3->X3_F3,;
									SX3->X3_CONTEXT } )
			
			ElseIf AllTrim(SX3->X3_CAMPO) == "A5_NOMPROD"
				aAdd(aHeadGet,{ 	"Descr.Produto" ,;
									SX3->X3_CAMPO,;
									"@S45" /*SX3->X3_PICTURE*/,;
									SX3->X3_TAMANHO,;
									SX3->X3_DECIMAL,;
									SX3->X3_VALID,;
									SX3->X3_USADO,;
									SX3->X3_TIPO,;
									SX3->X3_F3,;
									SX3->X3_CONTEXT } )
				
			ElseIf AllTrim(SX3->X3_CAMPO) == "A5_CODPRF"
				aAdd(aHeadGet,{ 	"Produto XML",;
									SX3->X3_CAMPO,;
									SX3->X3_PICTURE,;
									nMaxCodprf,;
									SX3->X3_DECIMAL,;
									SX3->X3_VALID,;
									SX3->X3_USADO,;
									SX3->X3_TIPO,;
									SX3->X3_F3,;
									SX3->X3_CONTEXT } )
									 			
			ElseIf AllTrim(SX3->X3_CAMPO) == "Z11_DESPRO"
				aAdd(aHeadGet,{ 	"Descr.Prod.XML" ,;
									SX3->X3_CAMPO,;
									"@S45" /*SX3->X3_PICTURE*/,;
									SX3->X3_TAMANHO,;
									SX3->X3_DECIMAL,;
									SX3->X3_VALID,;
									SX3->X3_USADO,;
									SX3->X3_TIPO,;
									SX3->X3_F3,;
									SX3->X3_CONTEXT } )
									
			ElseIf AllTrim(SX3->X3_CAMPO) == "B1_UM"
				aAdd(aHeadGet,{ 	"UM" ,;
									SX3->X3_CAMPO,;
									SX3->X3_PICTURE,;
									SX3->X3_TAMANHO,;
									SX3->X3_DECIMAL,;
									SX3->X3_VALID,;
									SX3->X3_USADO,;
									SX3->X3_TIPO,;
									SX3->X3_F3,;
									SX3->X3_CONTEXT } )
			
			ElseIf AllTrim(SX3->X3_CAMPO) == "Z11_UM"
				aAdd(aHeadGet,{ 	"UM XML" ,;
									SX3->X3_CAMPO,;
									SX3->X3_PICTURE,;
									SX3->X3_TAMANHO,;
									SX3->X3_DECIMAL,;
									SX3->X3_VALID,;
									SX3->X3_USADO,;
									SX3->X3_TIPO,;
									SX3->X3_F3,;
									SX3->X3_CONTEXT } )
			Else
				aAdd(aHeadGet,{ 	AllTrim(X3Titulo()),;
									SX3->X3_CAMPO,;
									SX3->X3_PICTURE,;
									SX3->X3_TAMANHO,;
									SX3->X3_DECIMAL,;
									SX3->X3_VALID,;
									SX3->X3_USADO,;
									SX3->X3_TIPO,;
									SX3->X3_F3,;
									SX3->X3_CONTEXT } )
									 
			ENDIF
		EndIf              	
	ENDIF
Next nI   

nA5PRODUTO	:= Ascan(aHeader,{ |x| alltrim(x[2]) == "A5_PRODUTO" } )
nA5NOMPROD 	:= Ascan(aHeader,{ |x| alltrim(x[2]) == "A5_NOMPROD" } )
nA5CODPRF	:= Ascan(aHeader,{ |x| alltrim(x[2]) == "A5_CODPRF" } )
//excluída linha abaixo [Mauro Nagata, www.compila.com.br, 20200308]
//nB1DESC		:= Ascan(aHeader,{ |x| alltrim(x[2]) == "B1_DESC" } )

nA5FABR		:= Ascan(aHeader,{ |x| alltrim(x[2]) == "A5_FABR" } )
nA5LJFB		:= Ascan(aHeader,{ |x| alltrim(x[2]) == "A5_FALOJA" } )
//excluída linha abaixo [Mauro Nagata, www.compila.com.br, 20200308]
//incluída linha abaixo [Mauro Nagata, Compila, 20200212]
//nB1UM		:= aScan(aHeader,{ |x| AllTrim(x[2]) == "B1_UM" } )
//substituído bloco acima pelo abaixo [Mauro Nagata, www.compila.com.br, 20200308]
/*
nA5PRODUTO	:= Ascan(aHeader,{ |x| alltrim(x[2]) == "B1_COD" } )
nA5NOMPROD 	:= Ascan(aHeader,{ |x| alltrim(x[2]) == "B1_DESC" } )
nA5CODPRF	:= Ascan(aHeader,{ |x| alltrim(x[2]) == "Z11_CODPRO" } )
nB1DESC		:= Ascan(aHeader,{ |x| alltrim(x[2]) == "Z11_DESPRO" } )
nA5FABR		:= Ascan(aHeader,{ |x| alltrim(x[2]) == "A5_FABR" } )
nA5LJFB		:= Ascan(aHeader,{ |x| alltrim(x[2]) == "A5_FALOJA" } )
*/
nDESCZ11	:= Ascan(aHeader,{ |x| alltrim(x[2]) == "Z11_DESPRO" } )
nUMZ11		:= aScan(aHeader,{ |x| AllTrim(x[2]) == "Z11_UM" } )
nUMSB1		:= aScan(aHeader,{ |x| AllTrim(x[2]) == "B1_UM" } )

          
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Preenche aCols ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
FOR nY := 1 to LEN(aProdFor)
	Aadd(aColsGet,Array(nUsado+1))
	
	For nI := 1 To nUsado 
	
		IF nA5CODPRF == nI        	//codigo produto XML            
		    aColsGet[len(aColsGet)][nI] := CriaVar(aHeadGet[nI][2],.T.)		
		    aColsGet[len(aColsGet)][nI] := aProdFor[nY, 1]
		/*    
		ELSEIF nB1DESC == nI
		    aColsGet[len(aColsGet)][nI] := CriaVar(aHeadGet[nI][2],.T.)				
		    aColsGet[len(aColsGet)][nI] := aProdFor[nY, 2]
		    
		ELSE
		*/
		//substituída linha acima pelo bloco abaixo [Mauro Nagata, Compila, 20200212]
		//ElseIf nB1UM == nI
		//substituída linha acima pelo bloco abaixo [Mauro Nagata, Compila, 20200308]
		ElseIf nDESCZ11 == nI		//descrição do produto XML
		    aColsGet[Len(aColsGet)][nI] := CriaVar(aHeadGet[nI][2],.T.)				
		    aColsGet[Len(aColsGet)][nI] := aProdFor[nY, 2]
		ElseIf nA5NOMPROD == nI		//nome do produto
				aColsGet[Len(aColsGet)][nI] := CriaVar(aHeadGet[nI][2],.T.)
				aColsGet[Len(aColsGet)][nI] := ""
		ElseIf nUMSB1 == nI			//unidade de medida do produto
				aColsGet[Len(aColsGet)][nI] := CriaVar(aHeadGet[nI][2],.T.)				
		ElseIf nUMZ11 == nI			//unidade de medida produto XML
				aColsGet[Len(aColsGet)][nI] := CriaVar(aHeadGet[nI][2],.T.)				
				aColsGet[Len(aColsGet)][nI] := aProdFor[nY, 3]
		Else
		    aColsGet[Len(aColsGet)][nI] := CriaVar(aHeadGet[nI][2],.T.)		
		ENDIF
	Next nI
	
	aColsGet[len(aColsGet)][nUsado+1] := .F.	
NEXT nY

Return

                             



/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ GrvProdForºAutor ³ Augusto Ribeiro	 º Data ³  16/12/2010 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Grava Amarracao Produto x Fornecedor                       º±±
±±º          ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function GrvProdFor(aCols, cCodFor, cLoja)
Local nTotReg	:= len(aCols)
Local nI
Local aRet	:= {.T.,""}
Local aDados := {}
Local aErroModel	:= {}
Local nOpc := 3
Local oModel := Nil
Local aArea

ProcRegua(nTotReg)

FOR nI := 1 TO nTotReg
	IncProc("Granva... ")
	aErroModel	:= {}
	
	aArea	:= GETAREA()
	
	IF !EMPTY(aCols[nI,nA5PRODUTO])
		aDados := {}
		aadd(aDados, {"A5_FORNECE"		,cCodFor				,nil})
		aadd(aDados, {"A5_LOJA"	 		,cLoja					,nil})	
		aadd(aDados, {"A5_PRODUTO"		,aCols[nI,nA5PRODUTO]	,nil})
		aadd(aDados, {"A5_CODPRF"		,aCols[nI,nA5CODPRF]	,nil})	
		
		IF !EMPTY(aCols[nI,nA5FABR]) .AND. !EMPTY(aCols[nI,nA5LJFB]) 
			aadd(aDados, {"A5_FABR"			,aCols[nI,nA5FABR]	,nil})	
			aadd(aDados, {"A5_FALOJA"		,aCols[nI,nA5LJFB]	,nil})	
		ENDIF 
	    
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica se o produto nao existe ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		DBSELECTAREA("SA2")
		SA2->(DBGOTOP(1))
		DBSEEK(XFILIAL("SA2")+cCodFor+cLoja)
		
		
		DBSELECTAREA("SA5")
		SA5->(DBSETORDER(1)) //| A5_FILIAL, A5_FORNECE, A5_LOJA, A5_PRODUTO			
		SA5->(DBGOTOP())
		IF SA5->(DBSEEK(XFILIAL("SA5")+cCodFor+cLoja+aCols[nI,nA5PRODUTO],.F.))	 
			IF EMPTY(SA5->A5_CODPRF)
				RECLOCK("SA5",.F.) 
					SA5->A5_CODPRF	:= aCols[nI,nA5CODPRF] 
				SA5->(MSUNLOCK())
			ELSEIF ALLTRIM(SA5->A5_CODPRF) !=  aCols[nI,nA5CODPRF]
//				lMsErroAuto := .F.			
				
				nOpc := 3
				oModel := Nil
				
				oModel := FWLoadModel('MATA061')
				
				oModel:SetOperation(nOpc)
				oModel:Activate()
				
				//Cabeçalho
				oModel:SetValue('MdFieldSA5','A5_PRODUTO', aCols[nI,nA5PRODUTO])
				
				//Grid
				oModel:SetValue('MdGridSA5','A5_FORNECE',cCodFor )
				oModel:SetValue('MdGridSA5','A5_LOJA' 	,cLoja)		
				oModel:SetValue('MdGridSA5','A5_CODPRF' ,aCols[nI,nA5CODPRF])																												
				
				If oModel:VldData()
					oModel:CommitData()
				Else
					aErroModel	:= oModel:GetErrorMessage()
					
					aRet[1]	:= .F.
					//aRet[2]	+= EOL+REPLICATE('-',80)+EOL+"Falha ao Gravar Produto X Fornecedor:3"
					//substituída linha acima pelo bloco abaixo [Mauro Nagata, Compila, 20200212]
					aRet[2]	+= 	CRLF + Replicate('-',80)+;
								CRLF + "Falha ao Gravar Produto X Fornecedor:3"+;
								CRLF + "Fornecedor [" + cCodFor + "]"+;
								CRLF + "Loja [" + cLoja + "]"+;
								CRLF + "Produto Fornecedor [" + aCols[nI,nA5CODPRF] + "]"
								
					IF LEN(aErroModel) >= 6 
						aRet[2]	+= CRLF+aErroModel[6]
					ENDIF
					//fim bloco [Mauro Nagata, Compila, 20200212]
				Endif
				
				oModel:DeActivate()
				
				oModel:Destroy()			
//				MSExecAuto({|x,y| Mata061(x,y)},aDados,3)	
//			
//				IF lMsErroAuto     
//					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//					//³ Realiza rollback ³
//					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//					aRet[1]	:= .F.
//					aRet[2]	+= EOL+REPLICATE('-',80)+EOL+"Falha ao Gravar Produto x Fornecedor:"
//					                       		
//					IF !EMPTY(NOMEAUTOLOG())
//						cLOGEXEC	:= MemoRead(NOMEAUTOLOG())							
//						aRet[2]		+= EOL+alltrim(cLOGEXEC)
//					ENDIF
//				ENDIF						 	
			ENDIF
		ELSE	                      
//			lMsErroAuto := .F.			
//			MSExecAuto({|x,y| Mata061(x,y)},aDados,3)	
//		
//			IF lMsErroAuto     
//				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//				//³ Realiza rollback ³
//				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//				aRet[1]	:= .F.
//				aRet[2]	+= EOL+REPLICATE('-',80)+EOL+"Falha ao Gravar Produto x Fornecedor:"
//				                       		
//				IF !EMPTY(NOMEAUTOLOG())
//					cLOGEXEC	:= MemoRead(NOMEAUTOLOG())							
//					aRet[2]		+= EOL+alltrim(cLOGEXEC)
//				ENDIF
//			ENDIF

			nOpc := 3
			oModel := Nil
			
			oModel := FWLoadModel('MATA061')
			
			oModel:SetOperation(nOpc)
			oModel:Activate()
			
			//Cabeçalho
			oModel:SetValue('MdFieldSA5','A5_PRODUTO', aCols[nI,nA5PRODUTO] )
			
			//Grid
			oModel:SetValue('MdGridSA5','A5_FORNECE', cCodFor)
			oModel:SetValue('MdGridSA5','A5_LOJA' 	, cLoja)			
			oModel:SetValue('MdGridSA5','A5_CODPRF' ,aCols[nI,nA5CODPRF])																										
			
			If oModel:VldData()
				oModel:CommitData()
			Else
				aErroModel	:= oModel:GetErrorMessage()
				
				aRet[1]	:= .F.
				//aRet[2]	+= EOL+REPLICATE('-',80)+EOL+"Falha ao Gravar Produto X Fornecedor:4"
				//substituída linha acima pelo bloco abaixo [Mauro Nagata, Compila, 20200212]
				aRet[2]	+= 	CRLF + Replicate('-',80)+;
							CRLF + "Falha ao Gravar Produto X Fornecedor:4" +;
							CRLF + EOL + "Fornecedor [" + cCodFor + "]"+;
							CRLF + "Loja [" + cLoja + "]"+;
							CRLF + "Produto Fornecedor [" + aCols[nI,nA5CODPRF] + "]"
							
				IF LEN(aErroModel) >= 6 
					aRet[2]	+= CRLF+aErroModel[6]
				ENDIF
							//EOL + "Amarração já existente para outro produto, verifique o cadastro de Produto x Fornecedor - SA5"
				//fim bloco [Mauro Nagata, Compila, 20200212]
			Endif
			
			oModel:DeActivate()
			
			oModel:Destroy()
		ENDIF
	ENDIF
	
	restarea(aArea)	
Next nI  

Return(aRet)


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CadForneceºAutor  ³ Augusto Ribeiro	 º Data ³  04/01/2011 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Cadastra Fornecedor sugerindo campos a serem preenchidos   º±±
±±º          ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static function CadFornece(oObjXml)
//User function CP01002I()
Local oObjXml, oEnd
Local cAliasImp		:= "SA2"
Local cFuncao		:= "MATA020"	//| Cadastro de Fornecedores
Local cTituloImp	:= "Cadastro de Fornecedores"  
Local cCNPJCPF		:= ""
Local aDadosCad		:= {} //{{"A2_NOME", "MAX FOREVER", Nil}}

	IF VALTYPE(oObjXml) == 'O'
                                 
                                         
		IF VALTYPE(XmlChildEx(oObjXml,"_CNPJ")) <> 'U'
			cCNPJCPF	:= alltrim(oObjXml:_CNPJ:TEXT)
		ELSEIF VALTYPE(XmlChildEx(oObjXml,"_CPF")) <> 'U'                                                
			cCNPJCPF	:= alltrim(oObjXml:_CPF:TEXT)
		ENDIF		               
//		aadd(aDadosCad, {"A2_FILIAL"	,XFILIAL("SA2"),Nil})				

		//|Tratativa em caso de falha no SXE e SXF 	
		_lExiste := .T.		
		_cCodForn := GETSXENUM("SA2","A2_COD")

		//|Busca código Valido				
		WHILE _lExiste  
			_lExiste	:= GetFornece(_cCodForn)
			
			IF _lExiste 
				_cCodForn := SOMA1(_cCodForn)			
			ENDIF			
		ENDDO

		aadd(aDadosCad, {"A2_COD"	,	_cCodForn				 ,Nil})		
		aadd(aDadosCad, {"A2_LOJA"	,	"01"					 ,Nil})		
	
		IF LEN(cCNPJCPF) == 14
			aadd(aDadosCad, {"A2_TIPO"	,	"J",Nil})
		ELSE 
			aadd(aDadosCad, {"A2_TIPO"	,	"F",Nil})		
		ENDIF	
		
		aadd(aDadosCad, {"A2_CGC"			,cCNPJCPF 	,Nil})			
		
		IF VALTYPE(XmlChildEx(oObjXml,"_XNOME")) <> 'U'		
			aadd(aDadosCad, {"A2_NOME"			,LEFT(UPPER(alltrim(oObjXml:_xNome:TEXT)), TAMSX3("A2_NOME")[1] - 1)  					,Nil})
		ENDIF		         
		IF VALTYPE(XmlChildEx(oObjXml,"_XFANT")) <> 'U'			
			IF !EMPTY(UPPER(alltrim(oObjXml:_xFant:TEXT)))
				aadd(aDadosCad, {"A2_NREDUZ"		,LEFT(UPPER(alltrim(oObjXml:_xFant:TEXT)), TAMSX3("A2_NREDUZ")[1] - 1   	)			,Nil})
			ELSE
				aadd(aDadosCad, {"A2_NREDUZ"		,LEFT(UPPER(alltrim(oObjXml:_xNome:TEXT)), TAMSX3("A2_NREDUZ")[1] - 1   	)			,Nil})
			ENDIF 	                 
		ELSE
			aadd(aDadosCad, {"A2_NREDUZ"			,LEFT(UPPER(alltrim(oObjXml:_xNome:TEXT)), TAMSX3("A2_NREDUZ")[1] - 1  		)			,Nil})			
		ENDIF		         
		
		
		IF VALTYPE(XmlChildEx(oObjXml,"_ENDEREMIT")) <> 'U'
			oEnd	:= oObjXml:_enderEmit
		ELSEIF VALTYPE(XmlChildEx(oObjXml,"_ENDERDEST")) <> 'U'
			oEnd	:= oObjXml:_enderDest
		ENDIF
		
		
		IF VALTYPE(XmlChildEx(oEnd,"_XLGR")) <> 'U'			
			aadd(aDadosCad, {"A2_END"			,alltrim(oEnd:_xLgr:TEXT)			,Nil})
			aadd(aDadosCad, {"A2_NR_END"		,alltrim(oEnd:_nro:TEXT)			,Nil})
		ENDIF		         
		IF VALTYPE(XmlChildEx(oEnd,"_XBAIRRO")) <> 'U'			
			aadd(aDadosCad, {"A2_BAIRRO"		,alltrim(oEnd:_xBairro:TEXT)			,Nil})
		ENDIF		                       
		
		IF VALTYPE(XmlChildEx(oEnd,"_XMUN")) <> 'U'			
			aadd(aDadosCad, {"A2_MUN"			,alltrim(oEnd:_xMun:TEXT)	 			,Nil})
		ENDIF
		
		IF VALTYPE(XmlChildEx(oEnd,"_UF")) <> 'U'			
			aadd(aDadosCad, {"A2_EST"			,alltrim(oEnd:_UF:TEXT)				,Nil})
			
			IF alltrim(oEnd:_UF:TEXT) <> "EX"		
				IF VALTYPE(XmlChildEx(oEnd,"_CMUN")) <> 'U'		
					aadd(aDadosCad, {"A2_COD_MUN"		,substr(alltrim(oEnd:_cMun:TEXT),3,5),Nil})
				ENDIF		         
			ENDIF			
		ENDIF	 
			         
		IF VALTYPE(XmlChildEx(oEnd,"_CEP")) <> 'U'			
			aadd(aDadosCad, {"A2_CEP"			,alltrim(oEnd:_CEP:TEXT)				,Nil})
		ENDIF		         
		IF VALTYPE(XmlChildEx(oEnd,"_FONE")) <> 'U'		
			aadd(aDadosCad, {"A2_DDD"			,PADL(left(oEnd:_fone:TEXT,2),TAMSX3("A2_DDD")[1],'0')				,Nil})
			aadd(aDadosCad, {"A2_TEL"			,Substr(alltrim(oEnd:_fone:TEXT),3,8),Nil})
		ENDIF	
		IF VALTYPE(XmlChildEx(oEnd,"_CPAIS")) <> 'U'		
			aadd(aDadosCad, {"A2_CODPAIS"		,PADL(alltrim(oEnd:_cPais:TEXT), TAMSX3("A2_CODPAIS")[1],'0') ,Nil})		
		ENDIF		
		IF VALTYPE(XmlChildEx(oObjXml,"_IE")) <> 'U'
			aadd(aDadosCad, {"A2_INSCR"		,alltrim(oObjXml:_IE:TEXT)	   						,Nil})
		ENDIF		         
		IF VALTYPE(XmlChildEx(oObjXml,"_IM")) <> 'U'
			aadd(aDadosCad, {"A2_INSCRM"		,alltrim(oObjXml:_IM:TEXT)	   						,Nil})
		ENDIF

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Rotina para Tratamento Manual ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		U_cpGrvCad(cAliasImp, cTituloImp, cFuncao, aDadosCad) 
	ENDIF

Return()  
              




/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CadClienteºAutor  ³ Augusto Ribeiro	 º Data ³  04/01/2011 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Cadastra Clientes sugerindo campos a serem preenchidos     º±±
±±º          ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static function CadCliente(oObjXml)
Local oObjXml  
Local cCNPJCPF		:= ""
Local _lExisteCl	:= .T.
Local _cCodClie		:= ""


Private cFuncao		:= "MATA030"	//| Cadastro de Clientes
Private cAliasImp	:= "SA1"
Private cTituloImp	:= "Cadastro de Clientes"
Private	aDadosCad		:= {} //{{"A2_NOME", "MAX FOREVER", Nil}}

	IF VALTYPE(oObjXml) == 'O'
                                 
                   
		IF VALTYPE(XmlChildEx(oObjXml,"_CNPJ")) <> 'U'
			cCNPJCPF	:= alltrim(oObjXml:_CNPJ:TEXT)
		ELSEIF VALTYPE(XmlChildEx(oObjXml,"_CPF")) <> 'U'                                                
			cCNPJCPF	:= alltrim(oObjXml:_CPF:TEXT)
		ENDIF		   
		
				//|Tratativa em caso de falha no SXE e SXF 	
		//_lExisteCl := .T.		
		_cCodClie := GETSXENUM("SA2","A2_COD")        
		
		//|Busca código Valido
		WHILE _lExisteCl
			_lExisteCl	:= GetCliente(_cCodClie)
			
			IF _lExisteCl
				_cCodClie := SOMA1(_cCodClie)
			ENDIF
		ENDDO
		
		aadd(aDadosCad, {"A1_COD"	,	_cCodClie				 ,Nil})		                       

//		aadd(aDadosCad, {"A1_COD"	,	GETSXENUM("SA1","A1_COD"),Nil})		
		aadd(aDadosCad, {"A1_LOJA"	,	"01"					 ,Nil})		
                                         
		IF LEN(cCNPJCPF) == 14
			aadd(aDadosCad, {"A1_PESSOA"	,	"J",Nil})
		ELSE 
			aadd(aDadosCad, {"A1_PESSOA"	,	"F",Nil})		
		ENDIF
        
		aadd(aDadosCad, {"A1_TIPO"		,		"F"	,Nil})
		aadd(aDadosCad, {"A1_CGC"		,cCNPJCPF	,Nil})

		
		
		IF LEN(cCNPJCPF) == 14
			aadd(aDadosCad, {"A2_TIPO"	,	"J",Nil})
		ELSE 
			aadd(aDadosCad, {"A2_TIPO"	,	"F",Nil})		
		ENDIF	
		
		aadd(aDadosCad, {"A2_CGC"			,cCNPJCPF 	,Nil})				
				                                                                                      
		
		IF VALTYPE(XmlChildEx(oObjXml,"_XNOME")) <> 'U'		
			aadd(aDadosCad, {"A1_NOME"			,UPPER(alltrim(oObjXml:_xNome:TEXT))	  					,Nil})
			
			IF VALTYPE(XmlChildEx(oObjXml,"_XFANT")) <> 'U'			
				aadd(aDadosCad, {"A1_NREDUZ"		,UPPER(alltrim(oObjXml:_XFant:TEXT))  					,Nil})
			ELSE
				aadd(aDadosCad, {"A1_NREDUZ"		,UPPER(alltrim(oObjXml:_xNome:TEXT)	)  					,Nil})					
			ENDIF		                                           
		ENDIF
		
		IF VALTYPE(XmlChildEx(oObjXml:_enderDest,"_XLGR")) <> 'U'			
			aadd(aDadosCad, {"A1_END"			,alltrim(oObjXml:_enderDest:_xLgr:TEXT)+", "+alltrim(oObjXml:_enderDest:_nro:TEXT)			,Nil})
		ENDIF		         
		IF VALTYPE(XmlChildEx(oObjXml:_enderDest,"_XBAIRRO")) <> 'U'			
			aadd(aDadosCad, {"A1_BAIRRO"		,alltrim(oObjXml:_enderDest:_xBairro:TEXT)			,Nil})
		ENDIF		         
		IF VALTYPE(XmlChildEx(oObjXml:_enderDest,"_CMUN")) <> 'U'		
			aadd(aDadosCad, {"A1_COD_MUN"		,substr(alltrim(oObjXml:_enderDest:_cMun:TEXT),3,5),Nil})
		ENDIF		         
		IF VALTYPE(XmlChildEx(oObjXml:_enderDest,"_XMUN")) <> 'U'			
			aadd(aDadosCad, {"A1_MUN"			,alltrim(oObjXml:_enderDest:_xMun:TEXT)	 			,Nil})
		ENDIF		         
		IF VALTYPE(XmlChildEx(oObjXml:_enderDest,"_UF")) <> 'U'			
			aadd(aDadosCad, {"A1_EST"			,alltrim(oObjXml:_enderDest:_UF:TEXT)				,Nil})
		ENDIF		
		IF VALTYPE(XmlChildEx(oObjXml:_enderDest,"_CEP")) <> 'U'			
			aadd(aDadosCad, {"A1_CEP"			,alltrim(oObjXml:_enderDest:_CEP:TEXT)				,Nil})
		ENDIF		             		
		IF VALTYPE(XmlChildEx(oObjXml:_enderDest,"_FONE")) <> 'U'		
			aadd(aDadosCad, {"A1_DDD"			,PADL(left(oObjXml:_enderDest:_fone:TEXT,2),TAMSX3("A2_DDD")[1],'0')				,Nil})
			aadd(aDadosCad, {"A1_TEL"			,Substr(alltrim(oObjXml:_enderDest:_fone:TEXT),3,8),Nil})
		ENDIF			
		IF VALTYPE(XmlChildEx(oObjXml:_enderDest,"_CPAIS")) <> 'U'		
			aadd(aDadosCad, {"A1_CODPAIS"		,PADL(alltrim(oObjXml:_enderDest:_cPais:TEXT), TAMSX3("A2_CODPAIS")[1],'0') ,Nil})		
		ENDIF		
		IF VALTYPE(XmlChildEx(oObjXml,"_IE")) <> 'U'
			aadd(aDadosCad, {"A1_INSCR"		,alltrim(oObjXml:_IE:TEXT)	   						,Nil})
		ENDIF		         
		IF VALTYPE(XmlChildEx(oObjXml,"_IM")) <> 'U'
			aadd(aDadosCad, {"A1_INSCRM"		,alltrim(oObjXml:_IM:TEXT)	   						,Nil})
		ENDIF

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Rotina para Tratamento Manual ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		U_cpGrvCad(cAliasImp, cTituloImp, cFuncao, aDadosCad) 
	ENDIF
Return()  


                           
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ ConvCFOP ºAutor  ³ Augusto Ribeiro	 º Data ³  13/06/2011 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Converter o CFOP                                            ±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
//Static Function ConvCFOP(cCFOP)
User Function CP0102CF(cCFOP)
Local cRet		:= ""
Local cCFOP1	:= ALLTRIM(U_CP01005G("11", "CONVCF1"))
Local nPosCF	:= 0
Local cCFOP2	:= ALLTRIM(U_CP01005G("11", "CONVCF2"))
Local cCFCHAR3	:= ""

IF !EMPTY(cCFOP) 
        
	cCFCHAR3	:= RIGHT(cCFOP,3)
        
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verific se a conversao e uma excecao ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	IF !EMPTY(cCFOP1)
		aCFOP1	:=  &(cCFOP1)
		
		nPosCF	:= Ascan(aCFOP1,{ |x| alltrim(x[1]) == cCFCHAR3 } )
		IF nPosCF > 0       
			cCFCHAR3	:= aCFOP1[nPosCF, 2]
		
		ELSEIF !EMPTY(cCFOP2)
			aCFOP2	:=  &(cCFOP2)
			
			nPosCF	:= Ascan(aCFOP2,{ |x| alltrim(x[1]) == cCFCHAR3 } )		
			IF nPosCF > 0       
				cCFCHAR3	:= aCFOP2[nPosCF, 2]			
			ENDIF		
		ENDIF		
	ENDIF
	     
	IF LEFT(cCFOP,1) == "5"
		cCFOP	:= "1"+cCFCHAR3
	ELSEIF LEFT(cCFOP,1) == "6"
		cCFOP	:= "2"+cCFCHAR3
	ENDIF 
	cRet	:= cCFOP
ENDIF

Return(cRet)
             

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ RetCliForºAutor  ³ Augusto Ribeiro	 º Data ³  13/06/2011 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Busca Fornecedor ou Cliente                                 ±±
±±ºPARAMETROS³ cCad (SA1, SA2), cCNPJ                                      ±±
±±ºRETORNO   ³ aRet	:= {cCodFor, cLojaFor, cRecno} o CFOP                  ±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function RetCliFor(cCad,cCNPJ, cRazao)
Local cCNPJ           
Local cQuery	:= ""
Local aRet		:= {}
     
IF !EMPTY(cCNPJ) .OR. !EMPTY(cRazao)

	cCNPJ	:= ALLTRIM(cCNPJ)   
	cRazao	:= UPPER(ALLTRIM(cRazao))

	IF cCad == "SA2"   
	              
		cRazao	:= LEFT(cRazao, TAMSX3("A2_NOME")[1])
	
		cQuery	:= " SELECT A2_COD, A2_LOJA, R_E_C_N_O_ AS A2_RECNO "
		cQuery	+= " FROM "+RetSqlName("SA2")
		cQuery	+= " WHERE A2_FILIAL = '"+XFILIAL("SA2")+"' " 
		IF !EMPTY(cCNPJ)
			cQuery	+= " AND A2_CGC = '"+cCNPJ+"' "
		ELSE
			cQuery	+= " AND A2_NOME = '"+cRazao+"' "
		ENDIF
		cQuery	+= " AND A2_MSBLQL <> '1'
		cQuery	+= " AND D_E_L_E_T_ = '' 
		
	ELSEIF cCad == "SA1"
	
		cRazao	:= LEFT(cRazao, TAMSX3("A1_NOME")[1])	
	
		cQuery	:= " SELECT A1_COD, A1_LOJA, R_E_C_N_O_ AS A1_RECNO "
		cQuery	+= " FROM "+RetSqlName("SA1")
		cQuery	+= " WHERE A1_FILIAL = '"+XFILIAL("SA1")+"' "
		IF !EMPTY(cCNPJ)		
			cQuery	+= " AND A1_CGC = '"+cCNPJ+"' "
		ELSE
			cQuery	+= " AND A1_NOME = '"+cRazao+"' "
		ENDIF		
		cQuery	+= " AND A1_MSBLQL <> '1'
		cQuery	+= " AND D_E_L_E_T_ = '' 			
	ENDIF
	       
	cQuery	:= ChangeQuery(cQuery)	
	
	TcQuery cQuery New Alias "TCAD"	                  
	
	IF TCAD->(!EOF())
		aRet	:= {TCAD->(FieldGet(1)), TCAD->(FieldGet(2)), TCAD->(FieldGet(3))}
	ENDIF	
	
	TCAD->(DBCLOSEAREA())      
ENDIF

Return(aRet)

                           
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ RemovCharºAutor  ³ Augusto Ribeiro	 º Data ³  08/06/2011 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Remove caracter especial                                   ±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
STATIC Function RemovChar(cRet)
Local cRet

cRet	:= upper(cRet)

cRet	:= STRTRAN(cRet,"Á","A")
cRet	:= STRTRAN(cRet,"É","E")
cRet	:= STRTRAN(cRet,"Í","I")
cRet	:= STRTRAN(cRet,"Ó","O")
cRet	:= STRTRAN(cRet,"Ú","U")
cRet	:= STRTRAN(cRet,"À","A")
cRet	:= STRTRAN(cRet,"È","E")
cRet	:= STRTRAN(cRet,"Ì","I")
cRet	:= STRTRAN(cRet,"Ò","O")
cRet	:= STRTRAN(cRet,"Ù","U")
cRet	:= STRTRAN(cRet,"Ã","A")
cRet	:= STRTRAN(cRet,"Õ","O")
cRet	:= STRTRAN(cRet,"Ä","A")
cRet	:= STRTRAN(cRet,"Ë","E")
cRet	:= STRTRAN(cRet,"Ï","I")
cRet	:= STRTRAN(cRet,"Ö","O")
cRet	:= STRTRAN(cRet,"Ü","U")
cRet	:= STRTRAN(cRet,"Â","A")
cRet	:= STRTRAN(cRet,"Ê","E")
cRet	:= STRTRAN(cRet,"Î","I")
cRet	:= STRTRAN(cRet,"Ô","O")
cRet	:= STRTRAN(cRet,"Û","U")
cRet	:= STRTRAN(cRet,"Ç","C")   

Return(cRet)
                



//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica se codigo ja existe ³
//³                             ³
//³Jonatas Oliveira - 20/06/2014³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function GetFornece(_cCodAuxF)   
Local cQry		:= ""
Local _lRetFor  := .F.

cQry := " SELECT * "
cQry += " FROM "+RetSqlName("SA2")+" SA2 "
cQry += " WHERE A2_FILIAL = '"+XFILIAL("SA2")+"' "
cQry += " AND A2_COD = '"+_cCodAuxF+"' "

cQry	:= ChangeQuery(cQry)

TcQuery cQry New Alias "TSCFOR"


IF TSCFOR->(!EOF())
	_lRetFor  := .T.
ENDIF							

TSCFOR->(DBCLOSEAREA())

Return(_lRetFor)



//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica se codigo ja existe ³
//³                             ³
//³Jonatas Oliveira - 20/06/2014³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function GetCliente(_cCodAuxF)
Local cQry		:= ""
Local _lRetFor  := .F.

cQry := " SELECT * "
cQry += " FROM "+RetSqlName("SA1")+" SA1 "
cQry += " WHERE A1_FILIAL = '"+XFILIAL("SA1")+"' "
cQry += " AND A1_COD = '"+_cCodAuxF+"' "

cQry	:= ChangeQuery(cQry)

TcQuery cQry New Alias "TSCCLI"


IF TSCCLI->(!EOF())
	_lRetFor  := .T.
ENDIF

TSCCLI->(DBCLOSEAREA())

Return(_lRetFor)


//Verifica proximo codigo de produto do fornecedor
Static Function MNTCODPR() 
Local cQry		:= ""
Local _cCodAux 	:= ""

cQry := " SELECT ISNULL(MAX(B1_COD),'') AS B1_COD "
cQry += " FROM "+RetSqlName("SB1")+" SB1 "
cQry += " WHERE B1_FILIAL = '"+XFILIAL("SB1")+"' "
cQry += " 	AND SUBSTRING(B1_COD,1,3) = 'XML' "
cQry += " 	AND SB1.D_E_L_E_T_ = '' "

cQry	:= ChangeQuery(cQry)

If Select("TSCODPR") > 0
	TSCODPR->(DbCloseArea())
EndIf

TcQuery cQry New Alias "TSCODPR"

IF TSCODPR->(!EOF()) .AND. !EMPTY(TSCODPR->B1_COD) 
	_cCodAux := SOMA1(TSCODPR->B1_COD)
ELSE
	_cCodAux := "XML"+STRZERO(1,TAMSX3("B1_COD")[1]-3)		
ENDIF 

TSCODPR->(DBCLOSEAREA())

Return(_cCodAux)





Static Function CadNfOrig(aItOrig, cCodFor, cLoja)
//USER Function CadProdFor(aItOrig)
Local aRet		:= {.F.,""}
Local aItOrig                              
Local aSize, aObjects, aInfo, aPosObj
Local oFLabels 	:= TFont():New("MS Sans Serif",,026,,.F.,,,,,.F.,.T.)
                             
Local aButtons	:= {}
Local bOK		:= {|| processa({|| aRet	:= GrvNfOrig(aCols, cCodFor, cLoja)}), oDlgCadFor:End()  }
Local bCanc		:= {|| oDlgCadFor:End()}
Local aCpoAlter	:= {"Z11_NFORIG","Z11_SERORI", "Z11_NFITOR" }
Local aCampos	:= {"Z11_ITEM", "Z11_CODPRO", "Z11_DESPRO", "Z11_CFOP", "Z11_UM","Z11_QUANT", "Z11_NFORIG", "Z11_SERORI", "Z11_NFITOR" }
                                            
Local cTitulo	:= "Nota de Origem"

Private oDlgCadFor
Private aHeader	:= {}
Private aCols	:= {}
Private bCampo	:= {|x| FieldName(x) }
Private aTela[0][0]
Private aGets[0]
                   
			
DBSELECTAREA("SA2")
SA2->(DBSETORDER(1))
SA2->(DBSEEK(XFILIAL("SA2")+cCodFor+cLoja))   


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Dimensionamento da Janela - Parte Superior ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aSize 		:= MsAdvSize()		
aObjects	 := {}
 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Caso chamada da funcao tenha sito feita pelo botao consultar log ³
//³ Redimenciona tela para melhor visualizacao                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aAdd( aObjects, {100,100, .T., .T.} )	

aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ]*0.60, aSize[ 4 ]*0.55, 3, 3 }
aPosObj 	:= MsObjSize( aInfo, aObjects, .T. )                                                                         

aPosObj[1,1] += 12  

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta Dialog ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DEFINE MSDIALOG oDlgCadFor TITLE cTitulo FROM aSize[7],00 to aSize[6]*0.60,aSize[5]*0.60 OF oMainWnd PIXEL		

@ aPosObj[1,1]-12, aPosObj[1,2] SAY oLblSolicita PROMPT SA2->(A2_COD+" - "+A2_LOJA+":"+A2_NOME) SIZE 131, 014 OF oDlgCadFor FONT oFLabels COLORS 128, 16777215 PIXEL

//ÚÄÄÄÄÄÄÄÄ¿
//³ BOTOES ³
//ÀÄÄÄÄÄÄÄÄÙ
//oSCVisual		:= TButton():New(aPosObj[1,1]-12, aPosObj[1,4]-150,"Gravar",oDlg,		{|| },045,010,,,,.T.,,"Gravar",,,,.F. )
                        
          
          
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Monta aHeader e aCols      	 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
MontGetO("SA5",@aHeader,@aCols, aCampos, aItOrig) 
 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Monta a GetDados.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
RegTomemory("SA5",.T.)
nOpc	:= 3
//MsGetDados():New( nTop, nLeft, nBottom, nRight, nOpc, [cLinhaOk], [cTudoOk], [cIniCpos], [lDelete], [aAlter], [uPar1], [lEmpty], [nMax], [cFieldOk], [cSuperDel], [uPar2], [cDelOk], [oWnd])
oGetSA5 := MSGetDados():New(aPosObj[1,1],aPosObj[1,2],aPosObj[1,3],aPosObj[1,4],nOpc,"AllwaysTrue","AllwaysTrue","",.F., aCpoAlter,,,len(aCols))

oGetSA5:nOpc	:= 3        

ACTIVATE MSDIALOG oDlgCadFor CENTERED  ON INIT Eval({ || EnChoiceBar(oDlgCadFor,bOK,bCanc,.F.,aButtons) })

Return(aRet)


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MontGetO ºAutor  ³ Augusto Ribeiro	 º Data ³  16/12/2010 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Monta a Header e aCols vazio                               º±±
±±º          ³                                                            º±±
±±º          ³ aHeader = Passar por referencia                            º±±
±±º          ³ aCols   = Passar por referencia                            º±±
±±º          ³ aCampos = Campos a serem listados                          º±±
±±º          ³ aItOrig = Cod Produto Fornecedor                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function MontGetO(cAliasGet,aHeadGet, aColsGet, aCampos, aItOrig)
Local nUsado	:= 0	
Local nY, nI   
Local nMaxCodprf	:= 0
Default aCampos	:= {}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta o aHeader.        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

aHeadGet := {}
aColsGet   := {}

DBSelectArea("SX3")
SX3->(DBSetOrder(2))
//SX3->(DBSeek(cAliasGet,.T.))

//While (SX3->(!Eof()) .And. SX3->X3_ARQUIVO == cAliasGet )

//FOR nI := 1 to LEN(aItOrig)   
//	IF LEN(ALLTRIM(aItOrig[nI, 1])) > nMaxCodprf
//		nMaxCodprf	:= LEN(ALLTRIM(aItOrig[nI, 1]))
//	ENDIF
//Next nI

FOR nI := 1 TO Len(aCampos)


	IF SX3->(DBSeek(aCampos[nI],.F.))	
		If 	X3USO(SX3->X3_USADO) 		.And. ;
			cNivel >= SX3->X3_NIVEL	
			
			nUsado++
			         
			IF ALLTRIM(SX3->X3_CAMPO) == "A5_CODPRF"
				aAdd(aHeadGet,{ 	AllTrim(X3Titulo()),;
									SX3->X3_CAMPO,;
									SX3->X3_PICTURE,;
									nMaxCodprf,;
									SX3->X3_DECIMAL,;
									SX3->X3_VALID,;
									SX3->X3_USADO,;
									SX3->X3_TIPO,;
									SX3->X3_F3,;
									SX3->X3_CONTEXT } ) 			
			ELSE
				aAdd(aHeadGet,{ 	AllTrim(X3Titulo()),;
									SX3->X3_CAMPO,;
									SX3->X3_PICTURE,;
									SX3->X3_TAMANHO,;
									SX3->X3_DECIMAL,;
									SX3->X3_VALID,;
									SX3->X3_USADO,;
									SX3->X3_TIPO,;
									SX3->X3_F3,;
									SX3->X3_CONTEXT } ) 
			ENDIF
		EndIf              	
	ENDIF
Next nI   

//{"Z11_ITEM", "Z11_CODPRO", "Z11_DESPRO", "Z11_CFOP", "Z11_UM","Z11_QUANT", "Z11_NFORIG", "Z11_SERORI"}

nOrgZ11IT	:= Ascan(aHeader,{ |x| alltrim(x[2]) == "Z11_ITEM" } )
nOrgZ11CD	:= Ascan(aHeader,{ |x| alltrim(x[2]) == "Z11_CODPRO" } )
nOrgZ11DS	:= Ascan(aHeader,{ |x| alltrim(x[2]) == "Z11_DESPRO" } )
nOrgZ11CF	:= Ascan(aHeader,{ |x| alltrim(x[2]) == "Z11_CFOP" } )
nOrgZ11UM	:= Ascan(aHeader,{ |x| alltrim(x[2]) == "Z11_UM" } )
nOrgZ11QT	:= Ascan(aHeader,{ |x| alltrim(x[2]) == "Z11_QUANT" } )

nOrgZ11NF	:= Ascan(aHeader,{ |x| alltrim(x[2]) == "Z11_NFORIG" } )
nOrgZ11SR	:= Ascan(aHeader,{ |x| alltrim(x[2]) == "Z11_SERORI" } )
nOrgZ11IM	:= Ascan(aHeader,{ |x| alltrim(x[2]) == "Z11_NFITOR" } )


/*
nA5PRODUTO	:= Ascan(aHeader,{ |x| alltrim(x[2]) == "A5_PRODUTO" } )
nA5NOMPROD 	:= Ascan(aHeader,{ |x| alltrim(x[2]) == "A5_NOMPROD" } )
nA5CODPRF	:= Ascan(aHeader,{ |x| alltrim(x[2]) == "A5_CODPRF" } )
nB1DESC		:= Ascan(aHeader,{ |x| alltrim(x[2]) == "B1_DESC" } )

nA5FABR		:= Ascan(aHeader,{ |x| alltrim(x[2]) == "A5_FABR" } )
nA5LJFB		:= Ascan(aHeader,{ |x| alltrim(x[2]) == "A5_FALOJA" } )
*/         
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Preenche aCols ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
FOR nY := 1 to LEN(aItOrig)
	Aadd(aColsGet,Array(nUsado+1))
	
	For nI := 1 To nUsado 
		IF nOrgZ11IT == nI  
			aColsGet[len(aColsGet)][nI] := CriaVar(aHeadGet[nI][2],.T.)		
		    aColsGet[len(aColsGet)][nI] := aItOrig[nY, nI]
		ELSEIF nOrgZ11CD == nI                                                     
		    aColsGet[len(aColsGet)][nI] := CriaVar(aHeadGet[nI][2],.T.)		
		    aColsGet[len(aColsGet)][nI] := aItOrig[nY, nI]
		ELSEIF nOrgZ11DS == nI                                                     
		    aColsGet[len(aColsGet)][nI] := CriaVar(aHeadGet[nI][2],.T.)		
		    aColsGet[len(aColsGet)][nI] := aItOrig[nY, nI]
		ELSEIF nOrgZ11CF == nI                                                     
		    aColsGet[len(aColsGet)][nI] := CriaVar(aHeadGet[nI][2],.T.)		
		    aColsGet[len(aColsGet)][nI] := aItOrig[nY, nI]	
		ELSEIF nOrgZ11UM == nI                                                     
		    aColsGet[len(aColsGet)][nI] := CriaVar(aHeadGet[nI][2],.T.)		
		    aColsGet[len(aColsGet)][nI] := aItOrig[nY, nI]
		ELSEIF nOrgZ11QT == nI                                                     
		    aColsGet[len(aColsGet)][nI] := CriaVar(aHeadGet[nI][2],.T.)		
		    aColsGet[len(aColsGet)][nI] := aItOrig[nY, nI]		
		ELSE 
		    aColsGet[len(aColsGet)][nI] := CriaVar(aHeadGet[nI][2],.T.)		
		ENDIF
	Next nI
	
	aColsGet[len(aColsGet)][nUsado+1] := .F.	
NEXT nY

Return

                             




/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ GrvNfOrigºAutor ³ Augusto Ribeiro	 º Data ³  16/12/2010 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Grava Amarracao Produto x Fornecedor                       º±±
±±º          ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function GrvNfOrig(aCols, cCodFor, cLoja)
Local nTotReg	:= len(aCols)
Local nI
Local aRet	:= {.T.,""}
Local aDados := {}
Local aArea		:= GetArea()
Local aAreaZ11	:= Z11->(GetArea())



ProcRegua(nTotReg)

Z11->(DBSETORDER(1))


nOrgZ11IT	:= Ascan(aHeader,{ |x| alltrim(x[2]) == "Z11_ITEM" } )
nOrgZ11CD	:= Ascan(aHeader,{ |x| alltrim(x[2]) == "Z11_CODPRO" } )
nOrgZ11DS	:= Ascan(aHeader,{ |x| alltrim(x[2]) == "Z11_DESPRO" } )
nOrgZ11CF	:= Ascan(aHeader,{ |x| alltrim(x[2]) == "Z11_CFOP" } )
nOrgZ11UM	:= Ascan(aHeader,{ |x| alltrim(x[2]) == "Z11_UM" } )
nOrgZ11QT	:= Ascan(aHeader,{ |x| alltrim(x[2]) == "Z11_QUANT" } )

nOrgZ11NF	:= Ascan(aHeader,{ |x| alltrim(x[2]) == "Z11_NFORIG" } )
nOrgZ11SR	:= Ascan(aHeader,{ |x| alltrim(x[2]) == "Z11_SERORI" } )
nOrgZ11IM	:= Ascan(aHeader,{ |x| alltrim(x[2]) == "Z11_NFITOR" } )

FOR nI := 1 TO nTotReg
	
	Z11->( DBSEEK( Z10->(Z10_FILIAL + Z10_CHVNFE + Z10_TIPARQ) + ALLTRIM(STR(aCols[nI][nOrgZ11IT])) ) )
	
	Z11->(RecLock("Z11",.F.))
		Z11->Z11_NFORIG := aCols[nI][nOrgZ11NF]
		Z11->Z11_SERORI := aCols[nI][nOrgZ11SR]
		Z11->Z11_NFITOR := aCols[nI][nOrgZ11IM]
	Z11->(MsUnLock())
	
	//IncProc("Granva... ")
	//
	//IF !EMPTY(aCols[nI,nA5PRODUTO])
	//	aDados := {}
	//	aadd(aDados, {"A5_FORNECE"		,cCodFor				,nil})
	//	aadd(aDados, {"A5_LOJA"	 		,cLoja					,nil})	
	//	aadd(aDados, {"A5_PRODUTO"		,aCols[nI,nA5PRODUTO]	,nil})
	//	aadd(aDados, {"A5_CODPRF"		,aCols[nI,nA5CODPRF]	,nil})	
	//	
	//	IF !EMPTY(aCols[nI,nA5FABR]) .AND. !EMPTY(aCols[nI,nA5LJFB]) 
	//		aadd(aDados, {"A5_FABR"			,aCols[nI,nA5FABR]	,nil})	
	//		aadd(aDados, {"A5_FALOJA"		,aCols[nI,nA5LJFB]	,nil})	
	//	ENDIF 
	//             
	//	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//	//³ Verifica se o produto nao existe ³
	//	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	//	DBSELECTAREA("SA5")
	//	SA5->(DBSETORDER(1)) //| A5_FILIAL, A5_FORNECE, A5_LOJA, A5_PRODUTO			
	//	
	//	IF SA5->(DBSEEK(XFILIAL("SA5")+cCodFor+cLoja+aCols[nI,nA5PRODUTO],.F.))	 
	//		IF EMPTY(SA5->A5_CODPRF)
	//			RECLOCK("SA5",.F.) 
	//				SA5->A5_CODPRF	:= aCols[nI,nA5CODPRF] 
	//			SA5->(MSUNLOCK())
	//		ELSEIF ALLTRIM(SA5->A5_CODPRF) !=  aCols[nI,nA5CODPRF]
	//			lMsErroAuto := .F.			
	//			MSExecAuto({|x,y| Mata061(x,y)},aDados,3)	
	//		
	//			IF lMsErroAuto     
	//				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//				//³ Realiza rollback ³
	//				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	//				aRet[1]	:= .F.
	//				aRet[2]	+= EOL+REPLICATE('-',80)+EOL+"Falha ao Gravar Produto x Fornecedor:"
	//				                       		
	//				IF !EMPTY(NOMEAUTOLOG())
	//					cLOGEXEC	:= MemoRead(NOMEAUTOLOG())							
	//					aRet[2]		+= EOL+alltrim(cLOGEXEC)
	//				ENDIF
	//			ENDIF						 	
	//		ENDIF
	//	ELSE	                      
	//		lMsErroAuto := .F.			
	//		MSExecAuto({|x,y| Mata061(x,y)},aDados,3)	
	//	
	//		IF lMsErroAuto     
	//			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//			//³ Realiza rollback ³
	//			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	//			aRet[1]	:= .F.
	//			aRet[2]	+= EOL+REPLICATE('-',80)+EOL+"Falha ao Gravar Produto x Fornecedor:"
	//			                       		
	//			IF !EMPTY(NOMEAUTOLOG())
	//				cLOGEXEC	:= MemoRead(NOMEAUTOLOG())							
	//				aRet[2]		+= EOL+alltrim(cLOGEXEC)
	//			ENDIF
	//		ENDIF
	//	ENDIF
	//ENDIF	
Next nI  


RestArea(aAreaZ11)
RestArea(aArea)
Return(aRet)


/*/{Protheus.doc} CP0102P
Cadastro de produto manual com base no XML
@author Jonatas Oliveira | www.compila.com.br
@since 17/09/2019
@version 1.0
/*/
User Function CP0102P(aHeader, aCols,  aProdFor, cCodFor, cLoja )
	Local aArea		:= GetArea()
	Local aAreaZ11	:= Z11->(GetArea())

	Z11->( DBGOTO(aProdFor[ n ][3] ) )
	
	
	nA5PRODUTO	:= Ascan(aHeader,{ |x| alltrim(x[2]) == "A5_PRODUTO" } )
	nA5NOMPROD 	:= Ascan(aHeader,{ |x| alltrim(x[2]) == "A5_NOMPROD" } )
	nA5CODPRF	:= Ascan(aHeader,{ |x| alltrim(x[2]) == "A5_CODPRF" } )
	nB1DESC		:= Ascan(aHeader,{ |x| alltrim(x[2]) == "B1_DESC" } )
	
	nA5FABR		:= Ascan(aHeader,{ |x| alltrim(x[2]) == "A5_FABR" } )
	nA5LJFB		:= Ascan(aHeader,{ |x| alltrim(x[2]) == "A5_FALOJA" } )
	
	DBSELECTAREA("SB1")
	SB1->(DBSETORDER(1))
	
	
	IF SB1->( !DBSEEK( XFILIAL("SB1") + aCols[ n ][ nA5CODPRF ] ) )									
		aDadosCad :=  {}   
		
		cAliasImp	:= "SB1"
		cFuncao		:= "MATA010"	//| Cadastro de Produtos
		cTituloImp	:= "Cadastro de Produtos"  
		aDadosCad	:= {} //estrutura do array {{"B1_DESC", "MAX FOREVER", Nil}}  
		
//		aadd(aDadosCad, {"B1_COD"	 ,ALLTRIM(Z11->Z11_CODPRO)	,Nil})
		aadd(aDadosCad, {"B1_DESC"   ,ALLTRIM(Z11->Z11_DESPRO)	,Nil})
		aadd(aDadosCad, {"B1_UM"     ,ALLTRIM(Z11->Z11_UM)		,Nil})                                   
		aadd(aDadosCad, {"B1_IPI"    ,Z11->Z11_IPIALQ			,Nil})
		aadd(aDadosCad, {"B1_POSIPI" ,ALLTRIM(Z11->Z11_POSIPI)	,Nil})
		aadd(aDadosCad, {"B1_SEGUM"  ,ALLTRIM(Z11->Z11_UM)		,Nil})
		aadd(aDadosCad, {"B1_LOCPAD" ,'01'						,Nil})
		aadd(aDadosCad, {"B1_IRRF"   ,'N'						,Nil})
		aadd(aDadosCad, {"B1_ORIGEM" ,ALLTRIM(Z11->Z11_ICORIG)	,Nil})  //Alterado por Eduardo Felipe em 18/06/14 - Adicionar a Origem do produto
	
		lAbortProd := U_cpGrvCad(cAliasImp, cTituloImp, cFuncao, aDadosCad)       
		IF !lAbortProd 
			aCols[ n ][ nA5PRODUTO ] 	:= ALLTRIM(SB1->B1_COD)
			aCols[ n ][ nA5NOMPROD ] 	:= ALLTRIM(SB1->B1_DESC)
		ENDIF 
		
		oDlgCadFor:Refresh()   
											 
	ENDIF 

	RestArea(aAreaZ11)
	RestArea(aArea)

Return()






/*/{Protheus.doc} GProdFor 
Utiliza amarração de tabela produto x fornecedor da Gomes da Costa
@author Augusto Ribeiro | www.compila.com.br
@since 15/02/2020
@version version
@param param
@return aRet, {.F., cMsgErro, cCodErp}
@example
(examples)
@see (links_or_references)
/*/
//Static Function GProdFor(cProdFor, cCodFor, cLojaFor, cProdERP, lCadastra)
User Function CPGPfor(cProdFor, cCodFor, cLojaFor, cProdERP, lCadastra)
Local cRet		:= ""
Local lFor		:= .f.
Local aRet		:= {.F., "", ""}
Local cChave	:= ""
//incluída linha abaixo [Mauro Nagata, www.compila.com.br, 20200227]
Local aArea := GetArea()

Default lCadastra	:= .f.

DBSELECTAREA("ZCC")
//ZCC->(DBSETORDER(1)) //| ZCC_FILIAL+ZCC_ORIGEM+ZCC_CLIFOR+ZCC_LOJA+ZCC_CODPRD+ZCC_CODPCF
ZCC->(DBSETORDER(2)) //| ZCC_FILIAL+ZCC_ORIGEM+ZCC_CLIFOR+ZCC_LOJA+ZCC_CODPCF+ZCC_CODPRD

cChave := xfilial("ZCC")+"SA2"+AVKEY(cCodFor,"ZCC_CLIFOR")+AVKEY(cLojaFor,"ZCC_LOJA")+AVKEY(cProdFor,"ZCC_CODPCF")
IF !EMPTY(cProdERP) 
	cChave := cChave + AVKEY(cProdERP,"ZCC_CODPRD")
ENDIF

IF ZCC->(DBSEEK(cChave)) 
	aRet[1]	:= .t. 	
	aRet[3]	:= 	ZCC->ZCC_CODPRD
	
ELSEIF lCadastra 


	IF !empty(cProdERP)
	
		DBSELECTAREA("SA2")
		IF SA2->A2_COD == cCodFor .AND. SA2->A2_LOJA == cLojaFor
			lFor	:= .t.
		ELSE
			SA2->(DBSETORDER(1)) //| 
			IF SA2->(DBSEEK(xfilial("SA1")+cCodFor+cLojaFor)) 
				lFor	:= .t.
			ENDIF	
		ENDIF
		
		IF lFor
			RegToMemory("ZCC", .T., .F.)
			
			RecLock("ZCC", .T.)
			
			M->ZCC_FILIAL	:= XFILIAL("ZCC")
			M->ZCC_ORIGEM	:= "SA2"
			M->ZCC_CLIFOR	:= SA2->A2_COD
			M->ZCC_LOJA		:= SA2->A2_LOJA
			M->ZCC_CGC		:= SA2->A2_CGC
			M->ZCC_NOME		:= SA2->A2_NOME
			M->ZCC_CODPCF	:= cProdFor
			M->ZCC_CODPRD	:= cProdERP
			
			nTotCpo	:= ZCC->(FCOUNT()) 
			For nI := 1 To nTotCpo
				cNameCpo	:= ALLTRIM(ZCC->(FIELDNAME(nI)))
				FieldPut(nI, M->&(cNameCpo) )
			Next nI
			
			ZCC->(MsUnLock())
			
			aRet[1]	:= .t. 	
			aRet[3]	:= cProdERP		
		ELSE
			aRet[2]	:= "Fornecedor nao localizado.["+cCodFor+cLojaFor+"] [GProdFor]"
		ENDIF
	ELSE
		aRet[2]	:= "Cod. do Produto ERP Vazio.["+cProdERP+"] [GProdFor]"
	ENDIF

ENDIF

//incluída linha abaixo [Mauro Nagata, www.compila.com.br, 20200227]
RestArea(aArea)

Return(aRet)


/*/{Protheus.doc} GGrvPFor 
Gravação Produto x Fornecedor Gomes da Costa (GrvProdFor)
@author Augusto Ribeiro | www.compila.com.br
@since 15/02/2020
@version undefined
@param param
@return return, return_description
@example
(examples)
@see (links_or_references)
/*/
//Static Function GGrvPFor(aCols, cCodFor, cLoja)
User Function CPGRPFor(aCols, cCodFor, cLoja)
Local nTotReg	:= len(aCols)
Local nI
Local aRet	:= {.T.,""}
Local aDados := {}
Local aErroModel	:= {}
Local nOpc := 3
Local oModel := Nil
Local aArea, aRetAux

ProcRegua(nTotReg)

FOR nI := 1 TO nTotReg
	IncProc("Granva... ")
	aErroModel	:= {}
	
	aArea	:= GETAREA()
	
	IF !EMPTY(aCols[nI,nA5PRODUTO])
	
		aRetAux	:= U_CPGPfor(aCols[nI,nA5CODPRF], cCodFor, cLoja, aCols[nI,nA5PRODUTO], .t.)	
	
		IF !(aRetAux[1])
			aRet[2]	+= 	CRLF + Replicate('-',80)+;
						CRLF + "Falha ao Gravar Produto X Fornecedor:4" +;
						CRLF + "Fornecedor [" + cCodFor + "]"+;
						CRLF + "Loja [" + cLoja + "]"+;
						CRLF + "Produto Fornecedor [" + aCols[nI,nA5CODPRF] + "]"+;
						CRLF + aRetAux[2]		
		ENDIF
		
	ENDIF
	
	

	restarea(aArea)	
Next nI  

Return(aRet)




User Function CP002FOK()


Local aArea 	:= GetArea()
Local aAreaSB1	:= SB1->(GetArea())

aCols[n,3] := Posicione("SB1",1,xFilial("SB1")+M->A5_PRODUTO,"B1_UM")

Return .T.

