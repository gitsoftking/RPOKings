#Include 'Protheus.ch'
#INCLUDE "TopConn.ch"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ CP01011  ºAutor  ³ Thiago Nascimento	 º Data ³  24/01/2013 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Função que vincula notas especificas de entrada com as     º±±
±±º          ³ suas notas de saídas originais para utilizar na Execauto   º±±
±±º          ³ da geração da pré-nota, e documento de entrada			  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function CP0101X(_cFilial, _cProd, _cCliFor, _cLoja, _cNumDoC, _cSerie, _nQuant, _nPrUnit)

Local aRetPD3 := {} // Array de retorno da Função
Local cQuery  := ""
Local nCount  := 0
Local lSaldo  := .F.
Local lDifVal := .T.
Local nDif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Query que busca dados do poder de Terceiro ³                         
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cQuery := " SELECT B6_FILIAL, B6_CLIFOR, B6_DOC, B6_SERIE, B6_IDENT, B6_QUANT, B6_PRUNIT ,D2_ITEM, B6_TES " +CRLF
cQuery += " FROM " +RetSqlName("SB6")+" B6 WITH(NOLOCK) " +CRLF
cQuery += " INNER JOIN " +RetSqlName("SD2")+ " D2 WITH(NOLOCK) " +CRLF
cQuery += " ON  B6_FILIAL = D2_FILIAL " +CRLF
cQuery += " AND B6_CLIFOR = D2_CLIENTE " +CRLF
cQuery += " AND B6_DOC	  = D2_DOC " +CRLF
cQuery += " AND B6_SERIE = D2_SERIE " +CRLF
cQuery += " AND B6_PRODUTO = D2_COD " +CRLF
cQuery += " AND D2.D_E_L_E_T_ = '' " +CRLF
cQuery += " WHERE B6_FILIAL = '"+_cFilial+"' "+CRLF
cQuery += " AND B6_CLIFOR = '"+_cCliFor+"' " +CRLF
cQuery += " AND B6_LOJA = '"+_cLoja+"' " +CRLF
cQuery += " AND B6_PRODUTO = '"+_cProd+"' " +CRLF
cQuery += " AND B6_DOC = '"+ _cNumDoc+"' " +CRLF
cQuery += " AND B6_SERIE = '"+ _cSerie +"' "+CRLF
cQuery += " AND B6_UENT = '' " +CRLF
cQuery += " AND B6_SALDO > 0 " +CRLF
cQuery += " AND B6.D_E_L_E_T_ = '' " +CRLF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Close na TRB caso esteja em uso ³                         
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
IF Select("TRBSB6") > 0
	TRBSB6->(DBCLOSEAREA())
ENDIF

dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQuery),'TRBSB6')

DbSelectArea("TRBSB6")

TRBSB6->(DBGoTop())	
TRBSB6->( dbEval( {|| nCount++ } ) )	
TRBSB6->(DBGoTop())

IF 	nCount > 0
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Quando ocorrer apenas 1 registro ³
	//³ na TRBSB6 não entra no laço      ³                
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	IF nCount > 1
		
		While TRBSB6->(! EOF()) 
			
			// Valido quantidade para vincular poder de terceiro.				
			If TRBSB6->B6_QUANT >= _nQuant   
		 		
		 		IF  ROUND(TRBSB6->B6_PRUNIT,2) == _nPrUnit
					lSaldo  := .T.
					lDifVal := .F.			
					AADD(aRetPD3, .T.)
					AADD(aRetPD3 ,TRBSB6->B6_DOC   )
					AADD(aRetPD3 ,TRBSB6->B6_SERIE )
					AADD(aRetPD3, TRBSB6->D2_ITEM  )
					AADD(aRetPD3, TRBSB6->B6_IDENT )					
					AADD(aRetPD3, "Produto "+ALLTRIM(_cProd)+" vinculado ao poder de terceiro com sucesso" )
					AADD(aRetPD3, TRBSB6->B6_TES )
					EXIT
					
				ELSE					
					lDifVal := .T.	
					nDif    := ROUND(TRBSB6->B6_PRUNIT,2)						
				ENDIF
			
			ELSE
				lSaldo := .F.																	
			Endif
						
			TRBSB6->(DbSkip())
		Enddo
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Caso valores estajam <> no poder  ³
		//³ de 3º alimento o array de retorno ³                
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ		
		IF	lDifVal
								
			AADD(aRetPD3, .F.)
			AADD(aRetPD3, nil )
			AADD(aRetPD3 ,nil )
			AADD(aRetPD3 ,nil )
			AADD(aRetPD3, nil )
			AADD(aRetPD3, "Produto "+ALLTRIM(_cProd)+" com preço divergente no poder de terceiro PD3: " ;
			+ cValToChar(nDif) + " <> XML: " + cValToChar(_nPrUnit))
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Caso não tenha saldo no poder	  ³
		//³ de 3º alimento o array de retorno ³                
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ					
		ELSEIF ! lSaldo
		
			AADD(aRetPD3, .F.)
			AADD(aRetPD3, nil )
			AADD(aRetPD3 ,nil )
			AADD(aRetPD3 ,nil )
			AADD(aRetPD3, nil )
			AADD(aRetPD3, "Produto "+ALLTRIM(_cProd)+" com saldo insuficiente no poder de terceiro" ) 
		
		ENDIF			
	
	// Quando há apenas 1 registro na TRBSB6	
	ELSE
			// Valido quantidade para vincular poder de terceiro aqui também
			If TRBSB6->B6_QUANT >= _nQuant   
		 		
		 		IF  ROUND(TRBSB6->B6_PRUNIT,2) == _nPrUnit
					lSaldo := .T.
					lDifVal := .F.			
					AADD(aRetPD3, .T.)
					AADD(aRetPD3 ,TRBSB6->B6_DOC   )
					AADD(aRetPD3 ,TRBSB6->B6_SERIE )
					AADD(aRetPD3, TRBSB6->D2_ITEM  )
					AADD(aRetPD3, TRBSB6->B6_IDENT )					
					AADD(aRetPD3, "Produto "+ALLTRIM(_cProd)+" vinculado ao poder de terceiro com sucesso" )	
					AADD(aRetPD3, TRBSB6->B6_TES )			
					
				ELSE					
					lDifVal := .T.	
					nDif    := ROUND(TRBSB6->B6_PRUNIT,2)						
				ENDIF
			
			ELSE
				lSaldo := .F.																	
			Endif
					
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Caso valores estajam <> no poder  ³
		//³ de 3º alimento o array de retorno ³                
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ		
		IF	lDifVal
								
			AADD(aRetPD3, .F.)
			AADD(aRetPD3, nil )
			AADD(aRetPD3 ,nil )
			AADD(aRetPD3 ,nil )
			AADD(aRetPD3, nil )
			AADD(aRetPD3, "Produto "+ALLTRIM(_cProd)+" com preço divergente no poder de terceiro PD3: " ;
			+ cValToChar(nDif) + " <> XML: " + cValToChar(_nPrUnit))
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Caso não tenha saldo no poder	  ³
		//³ de 3º alimento o array de retorno ³                
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ					
		ELSEIF ! lSaldo
		
			AADD(aRetPD3, .F.)
			AADD(aRetPD3, nil )
			AADD(aRetPD3 ,nil )
			AADD(aRetPD3 ,nil )
			AADD(aRetPD3, nil )
			AADD(aRetPD3, "Produto "+ALLTRIM(_cProd)+" com saldo insuficiente no poder de terceiro" ) 
		
		ENDIF				
		
	ENDIF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Caso não tenha registro no poder   ³
//³ de 3º alimento o array de retorno  ³                
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ELSE
	
	AADD(aRetPD3, .F.)
	AADD(aRetPD3, nil )
	AADD(aRetPD3, nil )
	AADD(aRetPD3, nil )
	AADD(aRetPD3, nil )
	AADD(aRetPD3, "Produto "+ALLTRIM(_cProd)+" sem registro no poder de terceiro" )
	 
ENDIF	

Return(aRetPD3)                                                                                                          