#Include "Protheus.Ch"
#Include "rwmake.Ch"
#INCLUDE "TOPCONN.CH"
#INCLUDE 'FWMVCDEF.CH'
#INCLUDE "FWMBROWSE.CH"
#INCLUDE 'TBICONN.CH'

//| ------ PARAMETRO UTILIZADOS NO MVC --------------
#DEFINE D_TITULO 'Rateio Lote'
#DEFINE D_ROTINA 'CP01013'
#DEFINE D_ALIAS 'Z10'
#DEFINE D_MODEL 'Z16MODEL'

#DEFINE EOL			Chr(13)+Chr(10)  


/*/{Protheus.doc} CP01013

@author Jonatas Oliveira | www.compila.com.br
@since 23/04/2019
@version 1.0
/*/
User function CP01013()

	oBrowse := FWMBrowse():New()

	oBrowse:SetAlias(D_ALIAS)
	oBrowse:SetDescription(D_TITULO)

	oBrowse:SetFilterDefault( "Z10_CHVNFE == Z10->Z10_CHVNFE")

	oBrowse:Activate()

Return NIL

/*/{Protheus.doc} MenuDef
Botoes do MBrowser
@author Jonatas Oliveira | www.compila.com.br
@since 23/04/2019
@version 1.0
/*/
Static Function MenuDef()
	Local aRotina := {}

	ADD OPTION aRotina TITLE 'Pesquisar'  			ACTION 'PesqBrw'           	OPERATION 1 ACCESS 0
	ADD OPTION aRotina TITLE 'Visualizar' 			ACTION 'VIEWDEF.'+D_ROTINA 	OPERATION 2 ACCESS 0
	ADD OPTION aRotina TITLE 'Incluir'  			ACTION 'VIEWDEF.'+D_ROTINA 	OPERATION 3 ACCESS 0
	ADD OPTION aRotina TITLE 'Alterar'    			ACTION 'VIEWDEF.'+D_ROTINA 	OPERATION 4 ACCESS 0	
	ADD OPTION aRotina TITLE 'Excluir'    			ACTION 'VIEWDEF.'+D_ROTINA	OPERATION 5 ACCESS 0
	ADD OPTION aRotina TITLE 'Imprimir'   			ACTION 'VIEWDEF.'+D_ROTINA 	OPERATION 8 ACCESS 0	
	ADD OPTION aRotina TITLE 'Legenda'  			ACTION 'eval(oBrowse:aColumns[1]:GetDoubleClick())'             OPERATION 1 ACCESS 0		
	ADD OPTION aRotina TITLE 'Pesquisar'  			ACTION 'PesqBrw'           	OPERATION 1 ACCESS 0

Return aRotina



/*/{Protheus.doc} ModelDef
Definicoes do Model
@author Jonatas Oliveira | www.compila.com.br
@since 23/04/2019
@version 1.0
/*/
Static Function ModelDef()
	// Cria a estrutura a ser usada no Modelo de Dados
	Local oStruZ10 := FWFormStruct( 1, 'Z10', /*bAvalCampo*/,/*lViewUsado*/ )
	Local oStruZ11 := FWFormStruct( 1, 'Z11', /*bAvalCampo*/,/*lViewUsado*/ )
	Local oStruZ16 := FWFormStruct( 1, 'Z16', /*bAvalCampo*/,/*lViewUsado*/ )
	Local oModel

	// Cria o objeto do Mod elo de Dados
	oModel := MPFormModel():New(D_MODEL,  /*bPreValidacao*/ , { |oModel| CP013POS( oModel ) } , /*bCommit*/ , /*bCancel*/ )

	// Adiciona ao modelo uma estrutura de formulário de edição por campo
	oModel:AddFields( 'Z10CABEC'	, /*cOwner*/, oStruZ10, /*bPreValidacao*/, /*bPosValidacao*/, /*bCarga*/ )
	oModel:AddGrid( 'Z11ITXML'		, 'Z10CABEC', oStruZ11, /*bLinePre*/, /*bLinePost*/, /*bPreVal*/, /*bPosVal*/, /*BLoad*/ )
	oModel:AddGrid( 'Z16RATEIO'		, 'Z11ITXML' , oStruZ16, /*bLinePre*/, /*bLinePost*/, /*bPreVal*/, /*bPosVal*/, /*BLoad*/ )

	// Faz relaciomaneto entre os compomentes do model
	oModel:SetRelation( 'Z11ITXML',		{{ 'Z11_FILIAL', 'XFILIAL("Z10")' }, { 'Z11_CHVNFE', 'Z10_CHVNFE' }, { 'Z11_TIPARQ', 'Z10_TIPARQ' } }, "Z11_FILIAL+Z11_CHVNFE+Z11_TIPARQ"/* Z16->(IndexKey(1))*/ )//Z16_FILIAL, Z16_CODIGO, Z16_ITEM, R_E_C_N_O_, D_E_L_E_T_
	oModel:SetRelation( 'Z16RATEIO',	{{ 'Z16_FILIAL', 'XFILIAL("Z11")' }, { 'Z16_CHVNFE', 'Z11_CHVNFE' }, { 'Z16_TIPARQ', 'Z11_TIPARQ' }  , { 'Z16_ITXML', 'Z11_ITEM' } }, "Z16_FILIAL+Z16_CHVNFE+Z16_TIPARQ+Z16_ITXML"/* Z16->(IndexKey(1))*/ )//Z16_FILIAL, Z16_CODIGO, Z16_ITEM, R_E_C_N_O_, D_E_L_E_T_

	oModel:GetModel( 'Z16RATEIO' ):SetOptional(.T.)

	// Adiciona a descricao do Modelo de Dados
	oModel:SetDescription(D_TITULO)

	// Adiciona a descricao do Componente do Modelo de Dados
	oModel:GetModel( 'Z10CABEC' ):SetDescription( 'Cabec XML' )
	oModel:GetModel( 'Z11ITXML' ):SetDescription( 'Itens XML' )
	oModel:GetModel( 'Z16RATEIO' ):SetDescription( 'Rateio' )


Return oModel


/*/{Protheus.doc} ViewDef
Definicoes da View
@author Jonatas Oliveira | www.compila.com.br
@since 23/04/2019
@version 1.0
/*/
Static Function ViewDef()
	// Cria um objeto de Modelo de Dados baseado no ModelDef do fonte informado
	Local oModel   := FWLoadModel( D_ROTINA )
	// Cria a estrutura a ser usada na View
	Local oStruZ10 := FWFormStruct( 2, 'Z10' )
	Local oStruZ11 := FWFormStruct( 2, 'Z11' )
	Local oStruZ16 := FWFormStruct( 2, 'Z16' )

	Local nOperation := oModel:GetOperation()
	Local oView
	
	Loca lAltVlr		:= U_CP01005G("11", "ALTERAVLR")


	// Liga a Edição de Campos na FormGrid
	oStruZ10:SetProperty( '*'				, MVC_VIEW_CANCHANGE  , .F. )
	oStruZ11:SetProperty( '*'				, MVC_VIEW_CANCHANGE  , .F. )
	oStruZ16:SetProperty( '*'				, MVC_VIEW_CANCHANGE  , .F. )

	oStruZ16:SetProperty(  'Z16_QUANT'	,  MVC_VIEW_CANCHANGE  , .T. )
	oStruZ16:SetProperty(  'Z16_LOTEFO'	,  MVC_VIEW_CANCHANGE  , .T. )
	oStruZ16:SetProperty(  'Z16_LOTECT'	,  MVC_VIEW_CANCHANGE  , .T. )
	oStruZ16:SetProperty(  'Z16_DTVALI'	,  MVC_VIEW_CANCHANGE  , .T. )
	
	IF lAltVlr
		oStruZ16:SetProperty(  'Z16_UM'		,  MVC_VIEW_CANCHANGE  , .T. )
		oStruZ16:SetProperty(  'Z16_VLRUNI'	,  MVC_VIEW_CANCHANGE  , .T. )
	ENDIF 
	
	// Cria o objeto de View
	oView := FWFormView():New()

	// Define qual o Modelo de dados será utilizado
	oView:SetModel( oModel )

	//Adiciona no nosso View um controle do tipo FormFields(antiga enchoice)
	oView:AddField( 'VIEW_Z10'	, oStruZ10, 'Z10CABEC' )
	oView:AddGrid( 'VIEW_Z11'	, oStruZ11, 'Z11ITXML' )
	oView:AddGrid( 'VIEW_Z16'	, oStruZ16, 'Z16RATEIO' )

	// Criar um "box" horizontal para receber algum elemento da view

	oView:CreateHorizontalBox( 'SUPERIOR'	, 40 )
	oView:CreateHorizontalBox( 'MEIO'		, 30 )
	oView:CreateHorizontalBox( 'INFERIOR'	, 30 )


	// Relaciona o ID da View com o "box" para exibicao
	oView:SetOwnerView( 'VIEW_Z10', 'SUPERIOR')
	oView:SetOwnerView( 'VIEW_Z11', 'MEIO')
	oView:SetOwnerView( 'VIEW_Z16', 'INFERIOR')

	oView:EnableTitleView('VIEW_Z11','Itens XML')
	oView:EnableTitleView('VIEW_Z16','Rateio Item')

	// Define campos que terao Auto Incremento
	oView:AddIncrementField( 'VIEW_Z16', 'Z16_ITEM' )

	//Gatilhos 
	oView:SetFieldAction(  'Z16_QUANT'  ,  {  |oView,  cIDView,  cField,  xValue|  GITECTR(  oView,  cIDView, cField, xValue ) } )
//	oView:SetFieldAction(  'Z16_LOTEFO' ,  {  |oView,  cIDView,  cField,  xValue|  GITECTR(  oView,  cIDView, cField, xValue ) } )
//	oView:SetFieldAction(  'Z16_LOTECT' ,  {  |oView,  cIDView,  cField,  xValue|  GITECTR(  oView,  cIDView, cField, xValue ) } )
//	oView:SetFieldAction(  'Z16_DTVALI' ,  {  |oView,  cIDView,  cField,  xValue|  GITECTR(  oView,  cIDView, cField, xValue ) } )
	oView:SetFieldAction(  'Z16_VLRUNI' ,  {  |oView,  cIDView,  cField,  xValue|  GITECTR(  oView,  cIDView, cField, xValue ) } )

	oView:SetCloseOnOk({||.T.})

Return oView


/*/{Protheus.doc} GITECTR
Preenche demais campos como Gatilho via SetFieldAction
@author Jonatas Oliveira | www.compila.com.br
@since 24/04/2019
@version 1.0
/*/
Static Function GITECTR( oView,  cIDView, cField, xValue)
	Local lOk		:= .F.
	Local oModFull 	:= oView:GetModel()
	Local oModZ10 	:= oModFull:GetModel('Z10CABEC')
	Local oModZ11 	:= oModFull:GetModel('Z11ITXML')
	Local oModZ16 	:= oModFull:GetModel('Z16RATEIO')
	
	Local nVlrTot	:= 0 
	Local aSaveLines := FWSaveRows()

	IF ALLTRIM(cField) == "Z16_QUANT"

		oModZ16:SetValue("Z16_ITXML"	, oModZ11:GetValue("Z11_ITEM")	)
		oModZ16:SetValue("Z16_TIPARQ"	, oModZ11:GetValue("Z11_TIPARQ"))
		oModZ16:SetValue("Z16_CHVNFE"	, oModZ11:GetValue("Z11_CHVNFE"))
		oModZ16:SetValue("Z16_NUMNFE"	, oModZ11:GetValue("Z11_NUMNFE"))
		oModZ16:SetValue("Z16_SERIE"	, oModZ11:GetValue("Z11_SERIE")	)
		oModZ16:SetValue("Z16_CNPJ"		, oModZ11:GetValue("Z11_CNPJ")	)
		oModZ16:SetValue("Z16_CODPRO"	, oModZ11:GetValue("Z11_CODPRO"))
		oModZ16:SetValue("Z16_DESPRO"	, oModZ11:GetValue("Z11_DESPRO"))
		oModZ16:SetValue("Z16_CFOP"		, oModZ11:GetValue("Z11_CFOP")	)
		oModZ16:SetValue("Z16_UM"		, oModZ11:GetValue("Z11_UM")	)
		oModZ16:SetValue("Z16_VLRUNI"	, oModZ11:GetValue("Z11_VLRUNI")	)

		oModZ16:SetValue("Z16_VLRTOT"	, oModZ16:GetValue("Z16_QUANT")	* oModZ16:GetValue("Z16_VLRUNI"))

	ENDIF 
	
	IF ALLTRIM(cField) == "Z16_VLRUNI"
		oModZ16:SetValue("Z16_VLRTOT"	, oModZ16:GetValue("Z16_QUANT")	* oModZ16:GetValue("Z16_VLRUNI"))
	ENDIF 
	
	FWRestRows( aSaveLines )
	oView:Refresh()

Return NIL

/*/{Protheus.doc} CP013POS
Valida a quantidade digitada
@author Jonatas Oliveira | www.compila.com.br
@since 05/06/2019
@version 1.0
/*/
Static Function CP013POS( oModel )
	Local lRet := .T.
//	Local nOperation := oModel:GetOperation
	Local oModFull 	:= oModel:GetModel()
	Local oModZ10 	:= oModFull:GetModel('Z10CABEC')
	Local oModZ11 	:= oModFull:GetModel('Z11ITXML')
	Local oModZ16 	:= oModFull:GetModel('Z16RATEIO')
	Local nTotZ11	:= 0 
	Local nTotZ16	:= 0 
	Local nVTtZ11	:= 0 
	Local nVTtZ16	:= 0 
	Local cMsgHlp	:= ""
	
	Local aSaveLines := FWSaveRows()
	
	Local lControL	:= U_CP01005G("11", "LOTECONTR")//|Permite avançar sem lote quando o produto(B1_RASTRO) estiver configurado? .T. ou .F.|
	Local lAchou
	Local nRecSA5	:= 0 
	
	Local aArea		:= GetArea()
	Local aAreaSA2	:= SA2->(GetArea())
	Local aAreaSB1	:= SB1->(GetArea())
			
	oModZ11:GoLine(1)
	
	DBSELECTAREA("SB1")
	SB1->(DBSETORDER(1))
	
	DBSELECTAREA("SA2")
	SA2->(DBSETORDER(3))
	
	For nY := 1 To oModZ11:Length()
		nTotZ11 := 0 
		nTotZ16	:= 0 
		
		nVTtZ11	:= 0 
		nVTtZ16	:= 0 
		
		oModZ11:GoLine(nY)
		
		nTotZ11 := oModZ11:GetValue("Z11_QUANT")
		nVTtZ11 := oModZ11:GetValue("Z11_VLRTOT")
		
		lAchou := .F.
		For nI := 1 To oModZ16:Length()
			oModZ16:GoLine(nI)
			
			IF oModZ16:GetValue("Z16_ITXML") == oModZ11:GetValue("Z11_ITEM")
				nTotZ16 += oModZ16:GetValue("Z16_QUANT")
				nVTtZ16 += oModZ16:GetValue("Z16_VLRTOT")
				
				lAchou := .T.
				
				IF !lControL 
					IF SB1->(DBSEEK(XFILIAL("SB1") + ALLTRIM(oModZ16:GetValue("Z16_CODPRO")))) .AND. SB1->B1_RASTRO == "L"	
						IF EMPTY( oModZ16:GetValue("Z16_LOTECT")) .OR.  EMPTY( oModZ16:GetValue("Z16_DTVALI")) 
							lRet := .F.
							cMsgHlp += "Produto com controle de lote. Necessário informar Lote e Validade: " + ALLTRIM(oModZ16:GetValue("Z16_CODPRO")) +EOL
						ENDIF			 
					ENDIF  
				ENDIF  
			
			ENDIF
			
		Next nI 
		
		IF nTotZ11 <> nTotZ16 .AND. nTotZ16 > 0 
			lRet := .F.
			cMsgHlp += "A soma das parcelas não confere com o valor com valor total do Item do XML "
//			Help(" ",1,"CP013POS",,"A soma das parcelas não confere com o valor com valor total do Item do XML ",4,5)	
		ENDIF 
		
		IF nVTtZ11 <> nVTtZ16 .AND. nVTtZ16 > 0 
			lRet := .F.
			cMsgHlp += "O valor unitário multiplicado pela Quantidade está diferente do Total. "
//			Help(" ",1,"CP013POS",,"O valor unitário multiplicado pela Quantidade está diferente do Total. ",4,5)	
		ENDIF 
		
		IF !lAchou .AND. !lControL 
			IF SB1->(DBSEEK(XFILIAL("SB1") + ALLTRIM(oModZ11:GetValue("Z11_CODPRO")))) 
				IF SB1->B1_RASTRO == "L"	
					IF EMPTY( oModZ11:GetValue("Z11_LOTECT")) .OR.  EMPTY( oModZ11:GetValue("Z11_DTVALI")) 
						lRet := .F.
						cMsgHlp += "Produto com controle de lote. Necessário informar Lote e Validade: " + ALLTRIM(oModZ11:GetValue("Z11_CODPRO")) +EOL
					ENDIF			 
				ENDIF			 
			ELSEIF SA2->(DBSEEK(XFILIAL("SA2") + oModZ10:GetValue("Z10_CNPJ") ))
				nRecSA5	:= ProdFor( ALLTRIM( oModZ11:GetValue("Z11_CODPRO") ), SA2->A2_COD, SA2->A2_LOJA)

				IF nRecSA5 > 0			
					SA5->(DBGOTO(nRecSA5))
						
					IF SB1->(DBSEEK(XFILIAL("SB1") + SA5->A5_PRODUTO))
						IF SB1->B1_RASTRO == "L"	
							IF EMPTY( oModZ11:GetValue("Z11_LOTECT")) .OR.  EMPTY( oModZ11:GetValue("Z11_DTVALI")) 
								lRet := .F.
								cMsgHlp += "Produto com controle de lote. Necessário informar Lote e Validade: " + ALLTRIM(oModZ11:GetValue("Z11_CODPRO")) +EOL
							ENDIF			 
						ENDIF	 
					ENDIF 		
				ENDIF 		

			ENDIF 			
		ENDIF 
		
	Next nY
	
	IF !lRet
		Help(" ",1,"CP013POS",, cMsgHlp ,4,5)
	ENDIF 
	
	FWRestRows( aSaveLines )


	RestArea(aAreaSB1)
	RestArea(aAreaSA2)
	RestArea(aArea)
	
Return(lRet)

/*/{Protheus.doc} Z16MODEL
Pontos de entrada da Rotina
@author Jonatas Oliveira | www.compila.com.br
@since 24/04/2019
@version 1.0
/*/
User Function Z16MODEL()
	Local aParam 		:= PARAMIXB
	Local xRet 			:= .T.
	Local oObj 			:= ""
	Local cIdPonto 		:= ""
	Local cIdModel 		:= ""
	Local lIsGrid 		:= .F.
	Local nLinha 		:= 0
	Local nQtdLinhas	:= 0
	Local nTotLen		:= 0
	Local nTotZ11		:= 0
	Local cMsg 			:= ""
	Local nOperation , oModFull , oModZ10 ,oModZ11, oModZ16
	Local aRet			:= {}
	Local aRetRC		:= {}
	Local aRetRA		:= {}
	Local nI			:= 0 
	Local nY			:= 0 
	Local nD			:= 0 
	Local aArea			:= GetArea()
	Local aAreaZ11		:= Z11->(GetArea())
	Local cChvZ11		:= ""
	Local aZ11Lim		:= {}
	Local aZ11Imp		:= {}
	Local nPosZ11		:= 0 



	If aParam <> NIL
		oObj := aParam[1]
		cIdPonto := aParam[2]
		cIdModel := aParam[3]
		lIsGrid := ( Len( aParam ) > 3 )

		nOperation	:= oObj:GetOperation()
		oModFull	:= oObj:GetModel()
		oModZ10 	:= oModFull:GetModel('Z10CABEC')
		oModZ11 	:= oModFull:GetModel('Z11ITXML')
		oModZ16 	:= oModFull:GetModel('Z16RATEIO')

		//		If lIsGrid
		//			nQtdLinhas :=  oModItem:Length()
		//		EndIf

		If cIdPonto == 'MODELCOMMITNTTS' //.AND. nOperation == MODEL_OPERATION_INSERT
			nTotLen	:= oModZ16:Length()

			cChvZ11	:= Z16->Z16_FILIAL + Z16->Z16_CHVNFE + Z16->Z16_TIPARQ

			DBSELECTAREA("Z16")
			Z16->(DBSETORDER(1))//|Z11_FILIAL+Z11_CHVNFE+Z11_TIPARQ+Z11_ITEM|				
			Z16->(DBGOTOP())

			IF Z16->(DBSEEK( cChvZ11 ))
				WHILE Z16->(!EOF()) .AND. cChvZ11 == Z16->Z16_FILIAL + Z16->Z16_CHVNFE + Z16->Z16_TIPARQ

					//|Deleta os Itens do XML|
					IF Z11->(DBSEEK( Z16->Z16_FILIAL + Z16->Z16_CHVNFE + Z16->Z16_TIPARQ + ALLTRIM( STR(Z16->Z16_ITXML) ))) 
						WHILE Z11->(!EOF()) .AND.  Z16->Z16_FILIAL + Z16->Z16_CHVNFE + Z16->Z16_TIPARQ + ALLTRIM( STR(Z16->Z16_ITXML) ) == Z11->(Z11_FILIAL + Z11_CHVNFE + Z11_TIPARQ + ALLTRIM( STR(Z11_ITEM)))
							aZ11Lim := {}
							
							AADD(aZ11Lim , Z11->Z11_ITEM)//|1
							AADD(aZ11Lim , Z11->Z11_QUANT)//|2
							AADD(aZ11Lim , Z11->Z11_ICORIG )//|3
							AADD(aZ11Lim , Z11->Z11_ICCST  )//|4
							AADD(aZ11Lim , Z11->Z11_ICVLR  )//|5
							AADD(aZ11Lim , Z11->Z11_ICSTBC )//|6
							AADD(aZ11Lim , Z11->Z11_ICSTAL )//|7
							AADD(aZ11Lim , Z11->Z11_IPICST )//|8
							AADD(aZ11Lim , Z11->Z11_PISCST )//|9
							AADD(aZ11Lim , Z11->Z11_CFCST  )//|10
							AADD(aZ11Lim , Z11->Z11_POSIPI )//|11
							AADD(aZ11Lim , Z11->Z11_NUMPC  )//|12
							AADD(aZ11Lim , Z11->Z11_ITEMPC )//|13
							AADD(aZ11Lim , Z11->Z11_NFORIG )//|14
							AADD(aZ11Lim , Z11->Z11_SERORI )//|15
							AADD(aZ11Lim , Z11->Z11_VLRDES )//|16
							AADD(aZ11Lim , Z11->Z11_ICBC   )//|17
							AADD(aZ11Lim , Z11->Z11_ICALQ  )//|18
							AADD(aZ11Lim , Z11->Z11_ICSTVL )//|19
							AADD(aZ11Lim , Z11->Z11_IPIBC  )//|20
							AADD(aZ11Lim , Z11->Z11_IPIALQ )//|21
							AADD(aZ11Lim , Z11->Z11_IPIVLR )//|22
							AADD(aZ11Lim , Z11->Z11_PISBC  )//|23
							AADD(aZ11Lim , Z11->Z11_PISALQ )//|24
							AADD(aZ11Lim , Z11->Z11_PISVLR )//|25
							AADD(aZ11Lim , Z11->Z11_CFBC   )//|26
							AADD(aZ11Lim , Z11->Z11_CFALQ  )//|27
							AADD(aZ11Lim , Z11->Z11_CFVLR  )//|28
							AADD(aZ11Lim , Z11->Z11_IIBC   )//|29
							AADD(aZ11Lim , Z11->Z11_IIADUA )//|30
							AADD(aZ11Lim , Z11->Z11_IIVLR  )//|31
							AADD(aZ11Lim , Z11->Z11_IIIOF  )//|32
							
							Z11->(RecLock("Z11",.F.))
								Z11->(DbDelete())		
							Z11->(MsUnLock())	
							
							AADD(aZ11Imp,aZ11Lim)

							Z11->(DBSKIP())
						ENDDO
					ENDIF

					Z16->(DBSKIP())
				ENDDO
			ENDIF 

			Z16->(DBGOTOP())

			//			nItem := 0 

			//|Refaz os itens do XML|
			IF Z16->(DBSEEK( cChvZ11 ))
				WHILE Z16->(!EOF()) .AND. cChvZ11 == Z16->Z16_FILIAL + Z16->Z16_CHVNFE + Z16->Z16_TIPARQ

					nItem := CP0113I(Z16->Z16_FILIAL , Z16->Z16_CHVNFE , Z16->Z16_TIPARQ)
					DBSELECTAREA("Z11")
					RegToMemory("Z11",.T.)

					nItem ++

					M->Z11_FILIAL		:= xFilial("Z11")
					M->Z11_TIPARQ       := Z16->Z16_TIPARQ
					M->Z11_CHVNFE       := Z16->Z16_CHVNFE
					M->Z11_NUMNFE       := Z16->Z16_NUMNFE 
					M->Z11_SERIE        := Z16->Z16_SERIE
					M->Z11_CNPJ         := Z16->Z16_CNPJ
					M->Z11_ITEM         := nItem
					M->Z11_CODPRO       := Z16->Z16_CODPRO
					M->Z11_DESPRO       := Z16->Z16_DESPRO
					M->Z11_CFOP         := Z16->Z16_CFOP
					M->Z11_UM           := Z16->Z16_UM
					M->Z11_QUANT        := Z16->Z16_QUANT
					M->Z11_VLRUNI       := Z16->Z16_VLRUNI
					M->Z11_VLRTOT       := Z16->Z16_VLRTOT
					M->Z11_LOTEFO       := Z16->Z16_LOTEFO
					M->Z11_LOTECT       := Z16->Z16_LOTECT 
					M->Z11_DTVALI       := Z16->Z16_DTVALI
					
					nPosZ11 := 0 
					nPosZ11 := aScan(aZ11Imp	, {|x| x[1] == Z16->Z16_ITXML })
					
					IF nPosZ11 > 0 
						//|Reacalcula impostos|
						M->Z11_ICORIG       := aZ11Imp[nPosZ11,3] 
						M->Z11_ICCST        := aZ11Imp[nPosZ11,4]  
						M->Z11_ICVLR        := aZ11Imp[nPosZ11,5]
						M->Z11_ICSTBC       := aZ11Imp[nPosZ11,6]
						M->Z11_ICSTAL       := aZ11Imp[nPosZ11,7]
						M->Z11_IPICST       := aZ11Imp[nPosZ11,8]
						M->Z11_PISCST       := aZ11Imp[nPosZ11,9]
						M->Z11_CFCST        := aZ11Imp[nPosZ11,10]
						M->Z11_POSIPI       := aZ11Imp[nPosZ11,11]
						M->Z11_NUMPC        := aZ11Imp[nPosZ11,12]
						M->Z11_ITEMPC       := aZ11Imp[nPosZ11,13]
						M->Z11_NFORIG       := aZ11Imp[nPosZ11,14]
						M->Z11_SERORI       := aZ11Imp[nPosZ11,15]
						
						M->Z11_VLRDES       := ( aZ11Imp[nPosZ11,16] / aZ11Imp[nPosZ11,2]) * Z16->Z16_QUANT
						M->Z11_ICBC         := ( aZ11Imp[nPosZ11,17] / aZ11Imp[nPosZ11,2]) * Z16->Z16_QUANT
						M->Z11_ICALQ        := ( aZ11Imp[nPosZ11,18] / aZ11Imp[nPosZ11,2]) * Z16->Z16_QUANT
						M->Z11_ICSTVL       := ( aZ11Imp[nPosZ11,19] / aZ11Imp[nPosZ11,2]) * Z16->Z16_QUANT
						M->Z11_IPIBC        := ( aZ11Imp[nPosZ11,20] / aZ11Imp[nPosZ11,2]) * Z16->Z16_QUANT
						M->Z11_IPIALQ       := ( aZ11Imp[nPosZ11,21] / aZ11Imp[nPosZ11,2]) * Z16->Z16_QUANT
						M->Z11_IPIVLR       := ( aZ11Imp[nPosZ11,22] / aZ11Imp[nPosZ11,2]) * Z16->Z16_QUANT
						M->Z11_PISBC        := ( aZ11Imp[nPosZ11,23] / aZ11Imp[nPosZ11,2]) * Z16->Z16_QUANT
						M->Z11_PISALQ       := ( aZ11Imp[nPosZ11,24] / aZ11Imp[nPosZ11,2]) * Z16->Z16_QUANT
						M->Z11_PISVLR       := ( aZ11Imp[nPosZ11,25] / aZ11Imp[nPosZ11,2]) * Z16->Z16_QUANT
						M->Z11_CFBC         := ( aZ11Imp[nPosZ11,26] / aZ11Imp[nPosZ11,2]) * Z16->Z16_QUANT
						M->Z11_CFALQ        := ( aZ11Imp[nPosZ11,27] / aZ11Imp[nPosZ11,2]) * Z16->Z16_QUANT
						M->Z11_CFVLR        := ( aZ11Imp[nPosZ11,28] / aZ11Imp[nPosZ11,2]) * Z16->Z16_QUANT
						M->Z11_IIBC         := ( aZ11Imp[nPosZ11,29] / aZ11Imp[nPosZ11,2]) * Z16->Z16_QUANT
						M->Z11_IIADUA       := ( aZ11Imp[nPosZ11,30] / aZ11Imp[nPosZ11,2]) * Z16->Z16_QUANT
						M->Z11_IIVLR        := ( aZ11Imp[nPosZ11,31] / aZ11Imp[nPosZ11,2]) * Z16->Z16_QUANT
						M->Z11_IIIOF        := ( aZ11Imp[nPosZ11,32] / aZ11Imp[nPosZ11,2]) * Z16->Z16_QUANT
						
					ENDIF 
					//					//|Reacalcula impostos|
					//					For nD := 1 To nTotZ11
					//						oModZ11:GoLine( nD )
					//
					//						IF oModZ16:GetValue("Z16_CHVNFE") + oModZ16:GetValue("Z16_TIPARQ") + ALLTRIM( STR(oModZ16:GetValue("Z16_ITXML"))) == oModZ11:GetValue("Z11_CHVNFE") + oModZ11:GetValue("Z11_TIPARQ") + ALLTRIM( STR(oModZ11:GetValue("Z11_ITEM")))
					//
					//							M->Z11_ICORIG       := oModZ11:GetValue("Z11_ICORIG") 
					//							M->Z11_ICCST        := oModZ11:GetValue("Z11_ICCST") 
					//							M->Z11_ICVLR        := oModZ11:GetValue("Z11_ICVLR") 
					//							M->Z11_ICSTBC       := oModZ11:GetValue("Z11_ICSTBC") 
					//							M->Z11_ICSTAL       := oModZ11:GetValue("Z11_ICSTAL") 
					//							M->Z11_IPICST       := oModZ11:GetValue("Z11_IPICST") 
					//							M->Z11_PISCST       := oModZ11:GetValue("Z11_PISCST") 
					//							M->Z11_CFCST        := oModZ11:GetValue("Z11_CFCST") 
					//							M->Z11_POSIPI       := oModZ11:GetValue("Z11_POSIPI") 
					//							M->Z11_NUMPC        := oModZ11:GetValue("Z11_NUMPC") 
					//							M->Z11_ITEMPC       := oModZ11:GetValue("Z11_ITEMPC") 
					//							M->Z11_NFORIG       := oModZ11:GetValue("Z11_NFORIG") 
					//							M->Z11_SERORI       := oModZ11:GetValue("Z11_SERORI") 
					//							M->Z11_VLRDES       := oModZ11:GetValue("Z11_VLRDES") 
					//
					//							M->Z11_ICBC         := ( oModZ11:GetValue("Z11_ICBC") 	/ oModZ11:GetValue("Z11_QUANT")) * oModZ16:GetValue("Z16_QUANT")
					//							M->Z11_ICALQ        := ( oModZ11:GetValue("Z11_ICALQ") 	/ oModZ11:GetValue("Z11_QUANT")) * oModZ16:GetValue("Z16_QUANT")
					//							M->Z11_ICSTVL       := ( oModZ11:GetValue("Z11_ICSTVL") / oModZ11:GetValue("Z11_QUANT")) * oModZ16:GetValue("Z16_QUANT")
					//							M->Z11_IPIBC        := ( oModZ11:GetValue("Z11_IPIBC") 	/ oModZ11:GetValue("Z11_QUANT")) * oModZ16:GetValue("Z16_QUANT")
					//							M->Z11_IPIALQ       := ( oModZ11:GetValue("Z11_IPIALQ") / oModZ11:GetValue("Z11_QUANT")) * oModZ16:GetValue("Z16_QUANT")
					//							M->Z11_IPIVLR       := ( oModZ11:GetValue("Z11_IPIVLR") / oModZ11:GetValue("Z11_QUANT")) * oModZ16:GetValue("Z16_QUANT")
					//							M->Z11_PISBC        := ( oModZ11:GetValue("Z11_PISBC") 	/ oModZ11:GetValue("Z11_QUANT")) * oModZ16:GetValue("Z16_QUANT")
					//							M->Z11_PISALQ       := ( oModZ11:GetValue("Z11_PISALQ") / oModZ11:GetValue("Z11_QUANT")) * oModZ16:GetValue("Z16_QUANT")
					//							M->Z11_PISVLR       := ( oModZ11:GetValue("Z11_PISVLR") / oModZ11:GetValue("Z11_QUANT")) * oModZ16:GetValue("Z16_QUANT")
					//							M->Z11_CFBC         := ( oModZ11:GetValue("Z11_CFBC") 	/ oModZ11:GetValue("Z11_QUANT")) * oModZ16:GetValue("Z16_QUANT")
					//							M->Z11_CFALQ        := ( oModZ11:GetValue("Z11_CFALQ") 	/ oModZ11:GetValue("Z11_QUANT")) * oModZ16:GetValue("Z16_QUANT")
					//							M->Z11_CFVLR        := ( oModZ11:GetValue("Z11_CFVLR") 	/ oModZ11:GetValue("Z11_QUANT")) * oModZ16:GetValue("Z16_QUANT")
					//							M->Z11_IIBC         := ( oModZ11:GetValue("Z11_IIBC") 	/ oModZ11:GetValue("Z11_QUANT")) * oModZ16:GetValue("Z16_QUANT")
					//							M->Z11_IIADUA       := ( oModZ11:GetValue("Z11_IIADUA") / oModZ11:GetValue("Z11_QUANT")) * oModZ16:GetValue("Z16_QUANT")
					//							M->Z11_IIVLR        := ( oModZ11:GetValue("Z11_IIVLR") 	/ oModZ11:GetValue("Z11_QUANT")) * oModZ16:GetValue("Z16_QUANT")
					//							M->Z11_IIIOF        := ( oModZ11:GetValue("Z11_IIIOF") 	/ oModZ11:GetValue("Z11_QUANT")) * oModZ16:GetValue("Z16_QUANT")
					//
					//							EXIT
					//						ENDIF 
					//					Next nD


					DBSELECTAREA("Z11")
					RECLOCK("Z11",.T.)

					For nY := 1 To Z11->(FCOUNT())
						FieldPut(nY, M->&(FieldName(nY)))
					Next nY	  

					Z11->(MSUNLOCK())
					
					/*----------------------------------------
						07/06/2019 - Jonatas Oliveira - Compila
						Atualiza o Item do Rateio
					------------------------------------------*/
					Z16->(RecLock("Z16",.F.))
						Z16->Z16_ITXML := nItem				
					Z16->(MsUnLock())

					Z16->(DBSKIP())
				ENDDO
			ENDIF 	
		ENDIF 

		//ApMsgInfo('Chamada apos a gravação total do modelo e fora da transação (MODELCOMMITNTTS).' + CRLF + 'ID ' + cIdModel)
		//ElseIf cIdPonto == 'FORMCOMMITTTSPRE'
	Endif 


	RestArea(aAreaZ11)
	RestArea(aArea)

Return xRet



Static Function CP0113I(cFilZ11 , cChvNfe , cTpArq)
	Local nRet		:= 0 
	Local cQuery 	:= ""


	cQuery 	+= " SELECT MAX(Z11_ITEM) AS Z11_ITEM "
	cQuery 	+= " FROM " + Retsqlname("Z11") + "  "	
	cQuery 	+= " WHERE D_E_L_E_T_ = '' "
	cQuery 	+= " 	AND Z11_FILIAL = '"+ cFilZ11 +"' "
	cQuery 	+= " 	AND Z11_CHVNFE = '"+ cChvNfe +"' "
	cQuery 	+= " 	AND Z11_TIPARQ = '"+ cTpArq +"' "

	If Select("QRYITM") > 0
		QRYITM->(DbCloseArea())
	EndIf

	dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQuery),'QRYITM')

	IF QRYITM->(!EOF())
		nRet := QRYITM->Z11_ITEM
	ENDIF 

Return (nRet)



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
	
//	MemoWrite(GetTempPath(.T.) + "ProdFor"+ STRTRAN(TIME(),":","") +".SQL", cQuery) 

	cQuery	:= ChangeQuery(cQuery)
	
	TcQuery cQuery New Alias "TSA5"	                  
	
	IF TSA5->(!EOF())
		nRet	:= TSA5->SA5_RECNO
	ENDIF	
	
	TSA5->(DBCLOSEAREA())      
Return(nRet)
