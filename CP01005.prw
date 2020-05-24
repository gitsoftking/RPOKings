#Include "Protheus.Ch"
#Include "rwmake.Ch"
#Include "TopConn.Ch"
#INCLUDE 'FWMVCDEF.CH'
#INCLUDE "FWMBROWSE.CH"     


#DEFINE aCpoCabec	{"Z08_CODIGO","Z08_DESC"}

//| TABELA
#DEFINE D_ALIAS 'Z08'
#DEFINE D_TITULO 'Configurador Importação'
#DEFINE D_ROTINA 'CP01005'
#DEFINE D_MODEL 'Z08MODEL'
#DEFINE D_MODELMASTER 'Z08MASTER'
#DEFINE D_VIEWMASTER 'VIEW_Z08'


/* - FWMVCDEF
MODEL_OPERATION_INSERT para inclusão;
MODEL_OPERATION_UPDATE para alteração;
MODEL_OPERATION_DELETE para exclusão.
*/

/*/{Protheus.doc} CP01005
DE/PARA Tabelas Adquirentes
@author Augusto Ribeiro | www.compila.com.br
@since 13/10/2017
@version version
@param param
@return return, return_description
@example
(examples)
@see (links_or_references)
/*/
User Function CP01005()
	Local oBrowse

	Private lDesOper	:= .F.
	Private lDesAmbi	:= .F.

	oBrowse := FWMBrowse():New()
	oBrowse:SetAlias(D_ALIAS)
	oBrowse:SetDescription(D_TITULO)

	oBrowse:Activate()

Return(NIL)



/*/{Protheus.doc} MenuDef
Botoes do MBrowser  
@author www.compila.com.br  
@version 1.0
/*/
Static Function MenuDef()
	Local aRotina := {}

	ADD OPTION aRotina TITLE 'Pesquisar'  ACTION 'PesqBrw'             OPERATION 1 ACCESS 0
	ADD OPTION aRotina TITLE 'Visualizar' ACTION 'VIEWDEF.'+D_ROTINA OPERATION 2 ACCESS 0                         
	ADD OPTION aRotina TITLE 'Incluir'  ACTION 'VIEWDEF.'+D_ROTINA OPERATION 3 ACCESS 0  	
	ADD OPTION aRotina TITLE 'Alterar'    ACTION 'VIEWDEF.'+D_ROTINA OPERATION 4 ACCESS 0
	ADD OPTION aRotina TITLE 'Excluir'    ACTION 'VIEWDEF.'+D_ROTINA OPERATION 5 ACCESS 0
	//ADD OPTION aRotina TITLE 'Copiar'     ACTION 'VIEWDEF.'+D_ROTINA OPERATION 9 ACCESS 0
	ADD OPTION aRotina TITLE 'Imprimir'   ACTION 'VIEWDEF.'+D_ROTINA OPERATION 8 ACCESS 0
	//ADD OPTION aRotina TITLE 'Legenda'  ACTION 'eval(oBrowse:aColumns[1]:GetDoubleClick())'             OPERATION 1 ACCESS 0



Return(aRotina)


/*/{Protheus.doc} ModelDef
Definicoes do Model 
@author www.compila.com.br
@version 1.0
/*/
Static Function ModelDef()

	// Cria a estrutura a ser usada no Modelo de Dados
	Local oStruZ08 := FWFormStruct( 1, D_ALIAS, { |cCampo| CPOCABEC(cCampo) } /*bAvalCampo*/,/*lViewUsado*/ )
	Local oStItemZ08 := FWFormStruct( 1, D_ALIAS, /*bAvalCampo*/,/*lViewUsado*/ )
	Local oModel, nI  



	/*------------------------------------------------------ Augusto Ribeiro | 12/10/2017 - 5:40:45 PM
	Altera inicializador PadrÃ£o dos itens para nÃ£o apresentar erro de campo
	obrigatorio nao preenchido
	------------------------------------------------------------------------------------------*/
	FOR nI := 1 to len(aCpoCabec)
		oStItemZ08:SetProperty(aCpoCabec[nI], MODEL_FIELD_INIT, FwBuildFeature(STRUCT_FEATURE_INIPAD, '"*"'))
	NEXT nI



	// Cria o objeto do Modelo de Dados
	oModel := MPFormModel():New(D_ROTINA+'MODEL',/*bPreValidacao*/, {  |oModel| POSMODEL( oModel ) },{  |oModel| GRVDADOS( oModel ) }  , {||RollbackSX8(), .T.} )

	// Adiciona ao modelo uma estrutura de formulÃ¡rio de ediÃ§Ã£o por campo
	oModel:AddFields( 'Z08MASTER', /*cOwner*/, oStruZ08, /*bPreValidacao*/, /*bPosValidacao*/, /*bCarga*/ )
	oModel:AddGrid( 'Z08ITENS', 'Z08MASTER', oStItemZ08, /* { |oModel, nLine, cAction, cField| PRELZZA(oModel, nLine, cAction, cField) } */ , /*{ |oModel, nLine, cAction, cField| POSLZZA(oModel, nLine, cAction, cField) } bLinePost*/, /*bPreVal*/,	 /*bPosVal*/, /*BLoad*/ )

	//oModel:SetRelation( 'ZA3VALEMP',	{{ 'ZA3_FILIAL', 'ZA1_FILIAL' }, { 'ZA3_CODIGO', 'ZA1_CODIGO' } , { 'ZA3_REV', 'ZA1_REV' }},"ZA3_FILIAL+ZA3_CODIGO+ZA3_REV" )
	oModel:SetRelation( 'Z08ITENS',	{{ 'Z08_FILIAL', 'XFILIAL("Z08")' }, { 'Z08_CODIGO', 'Z08_CODIGO' } },  "Z08_FILIAL+Z08_CODIGO" )


	// Liga o controle de nao repeticao de linha
	oModel:GetModel( 'Z08MASTER' ):SetPrimaryKey( { 'Z08_FILIAL', 'Z08_CODIGO'} )
	//oModel:GetModel( 'ZAWITENS' ):SetUniqueLine( { 'ZAW_FILIAL', 'ZAW_CODIND' } )

	//Se torna obrigatÃ³rio contÃ©udo da linha do Grid informado
	//oModel:GetModel( 'Z08ITENS' ):SetOptional(.T.)
	//oModel:GetModel( 'ZAWITENS' ):SetOptional(.T.)

	//Se torna a apenas visual o contÃ©udo da Linha do Grid informado
	oModel:GetModel( 'Z08MASTER' ):SetOnlyView ( .T. )   

	// Adiciona a descricao do Modelo de Dados
	oModel:SetDescription( D_TITULO )

	// Liga o controle de nao repeticao de linha
	//oModel:GetModel( 'Z08ITENS' ):SetUniqueLine( { 'Z08_CODCTR','Z08_REVCTR','Z08_ITECTR' } )


	oStItemZ08:SetProperty( 'Z08_CODIGO' , MODEL_FIELD_WHEN   , {|| .T.})


	// Liga a validaÃ§Ã£o da ativacao do Modelo de Dados
	//oModel:SetVldActivate( { |oModel,cAcao| U_FAT06VLD('MODEL_ACTIVE', oModel) } )

Return(oModel)


/*/{Protheus.doc} ViewDef
Definicoes da View 
@author www.compila.com.br
@version 1.0
/*/  
Static Function ViewDef()
	// Cria um objeto de Modelo de Dados baseado no ModelDef do fonte informado
	Local oModel   := FWLoadModel( D_ROTINA )
	// Para a interface (View) a funÃ§Ã£o FWFormStruct, traz para a estrutura os campos conforme o nÃ­vel, uso ou mÃ³dulo. 
	Local oStruZ08 := FWFormStruct( 2, D_ALIAS,  { |cCampo| CPOCABEC(cCampo) })
	Local oStItemZ08 := FWFormStruct( 2, D_ALIAS, { |cCampo| !CPOCABEC(cCampo) })

	Local oView, cOrdemCpo, nI
	Local aCpoView 	:= {} 




	// Cria o objeto de View
	oView := FWFormView():New()

	// Define qual o Modelo de dados serÃ¡ utilizado
	oView:SetModel( oModel )

	// Cria o objeto de Estrutura 


	//Adiciona no nosso View um controle do tipo FormFields(antiga enchoice)
	oView:AddField( D_VIEWMASTER , oStruZ08 , D_MODELMASTER )
	oView:AddGrid ( 'VIEW_Z08ITEM'   , oStItemZ08 , 'Z08ITENS' )
	//oView:AddGrid ( 'VIEW_ZAW'   , oStructZAW , 'ZAWITENS' )

	// Criar um "box" horizontal para receber algum elemento da view
	oView:CreateHorizontalBox( 'SUPERIOR'  , 30   )    
	oView:CreateHorizontalBox( 'INFERIOR'  , 70   )

	//oView:CreateVerticalBox( 'LEFT_INF1'	, 48 , 'INFERIOR' )
	//oView:CreateVerticalBox( 'RIGHT_INF'	, 52 , 'INFERIOR' )

	// Relaciona o ID da View com o "box" para exibicao
	oView:SetOwnerView( D_VIEWMASTER, 'SUPERIOR' )
	oView:SetOwnerView( "VIEW_Z08ITEM"  ,  'INFERIOR' )
	//oView:SetOwnerView( "VIEW_ZAW" , 'RIGHT_INF' )

	oView:AddIncrementField( 'VIEW_Z08ITEM', 'Z08_ITEM' )

	// Informa os titulos dos box da View
	oView:EnableTitleView(D_VIEWMASTER,'Cabecalho')
	oView:EnableTitleView('VIEW_Z08ITEM','Itens')
	//oView:EnableTitleView('VIEW_ZAW','HistÃ³rico de indÃ­ces %')


	//oView:SetFieldAction(  'Z08_ITECTR',  {  |oView,  cIDView,  cField,  xValue|  GITECTR(  oView,  cIDView, cField, xValue ) } )


	oView:SetCloseOnOk({||.T.})


Return(oView)



/*/{Protheus.doc} GRVDADOS
Gravacao dos dados 
@author www.compila.com.br
@version 1.0
/*/  
Static Function GRVDADOS(oModel)
	Local lRet	:= .T.
	Local nOperation	:= oModel:GetOperation()
	Local oModCabec	:= oModel:GetModel(D_MODELMASTER)
	Local oModItem		:= oModel:GetModel('Z08ITENS')
	Local cCodTicket	:= ""
	Local nI, nY


	IF nOperation == 3 .OR. nOperation == 4
		FOR nI := 1 to oModItem:Length()

			oModItem:GoLine( nI )


			FOR nY := 1 TO LEN(aCpoCabec)	
				oModItem:LOADVALUE(aCpoCabec[nY], oModCabec:GetValue(aCpoCabec[nY]))	
			NEXT nY

		next nI
	ENDIF


	aRet	:= GRVMODEL(oModItem)


Return(lRet)



  
/*/{Protheus.doc} POSMODEL

@author www.compila.com.br
@version 1.0
/*/  
Static Function POSMODEL(oModel)
	Local lRet	:= .T.
	Local nY, nAux
	Local nOperation	:= oModel:GetOperation()


Return(lRet)


/*/{Protheus.doc} GRVMODEL
Grava dados da Model no banco  
@author www.compila.com.br
@version 1.0
/*/  
Static Function GRVMODEL(oObjeto)
	Local aRet	:= {.F.,""}
	Local nOperation := oObjeto:GetOperation()
	Local cOldAlias	:= ""
	Local bBefore,bAfter,nOperation,oSuperObjeto, bAfterSTTS
	Local nY, nX, nLen, cAlias

	bBefore 	:= {|| .T.}
	bAfter		:= {|| .T.}
	bAfterSTTS	:= {|| .T.}

	cAlias	:= oObjeto:oFormModelStruct:GetTable()[FORM_STRUCT_TABLE_ALIAS_ID]

	IF !EMPTY(cAlias)

		aRelation := oObjeto:GetRelation()
		aDados    := oObjeto:GetData()
		aStruct   := oObjeto:oFormModelStruct:GetFields()
		IF ALLTRIM(oObjeto:ClassName()) == "FWFORMGRID"

			If (nOperation == MODEL_OPERATION_INSERT) .OR. (nOperation == MODEL_OPERATION_UPDATE)

				For nY := 1 To Len(aDados)
					oObjeto:GoLine(nY)
					lLock     := .F.
					nNextOper := 0
					//--------------------------------------------------------------------
					//Verifica o tipo de atualicao ( Insert ou Update )
					//--------------------------------------------------------------------
					If aDados[nY][MODEL_GRID_ID] <> 0
						//--------------------------------------------------------------------
						//Verifica se uma das linhas foi atualizada
						//--------------------------------------------------------------------
						For nX := 1 To Len(aStruct)
							If aDados[nY][MODEL_GRID_DATA][MODEL_GRIDLINE_UPDATE][nX]
								lLock := .T.
								Exit
							EndIf
						Next nX
						If aDados[nY][MODEL_GRID_DELETE] .Or. lLock
							(cAlias)->(MsGoto(aDados[nY][MODEL_GRID_ID]))
							RecLock(cAlias,.F.)
							lLock     := .T.
						EndIf
						nNextOper := nOperation
						If aDados[nY][MODEL_GRID_DELETE]
							nNextOper := MODEL_OPERATION_DELETE
						EndIf
					Else				
						For nX := 1 To Len(aStruct)
							If aDados[nY][MODEL_GRID_DATA][MODEL_GRIDLINE_UPDATE][nX] .And. !aDados[nY][MODEL_GRID_DELETE]
								lLock     := .T.
								nNextOper := nOperation
								Exit
							EndIf
						Next nX
						If lLock
							//--------------------------------------------------------------------
							//Quando as estruturas sao da mesma tabela - Modelo 2
							//--------------------------------------------------------------------
							If (nY == 1 .And. cAlias == cOldAlias)
								RecLock(cAlias,.F.)
							Else
								RecLock(cAlias,.T.)
							EndIf
						EndIf
					EndIf
					If lLock
						//--------------------------------------------------------------------
						//Executa o bloco de cÃ³digo de Pre-atualizaÃ§Ã£o
						//--------------------------------------------------------------------
						If !Empty(bBefore)
							(cAlias)->(Eval(bBefore,oObjeto,oObjeto:cID,cAlias))
						EndIf
						//--------------------------------------------------------------------
						//Verifica se a linha foi deletada
						//--------------------------------------------------------------------
						If aDados[nY][MODEL_GRID_DELETE]
							(cAlias)->(dbDelete())
						Else
							//--------------------------------------------------------------------
							//Efetua a gravacao dos campos                    
							//--------------------------------------------------------------------
							For nX := 1 To Len(aStruct)
								If aDados[nY][MODEL_GRID_DATA][MODEL_GRIDLINE_UPDATE][nX] .Or. aDados[nY][MODEL_GRID_ID] == 0
									If (cAlias)->(FieldPos(aStruct[nX][MODEL_FIELD_IDFIELD])) > 0
										(cAlias)->(FieldPut(FieldPos(aStruct[nX][MODEL_FIELD_IDFIELD]),aDados[nY][MODEL_GRID_DATA][MODEL_GRIDLINE_VALUE][nX]))
									EndIf
								EndIf
							Next nX
							If (cAlias)->(FieldPos(PrefixoCpo(cAlias)+"_FILIAL")) > 0 .And. nOperation == MODEL_OPERATION_INSERT .And. !Empty(xFilial(cAlias))
								(cAlias)->(FieldPut(FieldPos(PrefixoCpo(cAlias)+"_FILIAL"),xFilial(cAlias)))
							EndIf
							//--------------------------------------------------------------------
							//Efetua a gravacao das chaves estrangeiras       
							//--------------------------------------------------------------------
							For nX := 1 To Len(aRelation[MODEL_RELATION_RULES])
								oModel := Nil							
								If oObjeto:GetModel():GetIdField(aRelation[MODEL_RELATION_RULES][nX][MODEL_RELATION_RULES_TARGET],@oModel) == 0
									xValue := &(aRelation[MODEL_RELATION_RULES][nX][MODEL_RELATION_RULES_TARGET])
								Else								
									xValue := oModel:GetValue(aRelation[MODEL_RELATION_RULES][nX][MODEL_RELATION_RULES_TARGET])
								EndIf
								(cAlias)->(FieldPut(FieldPos(aRelation[MODEL_RELATION_RULES][nX][MODEL_RELATION_RULES_ORIGEM]),xValue))
							Next nX
							//--------------------------------------------------------------------
							//Efetua a gravacao do modelo 2                   
							//--------------------------------------------------------------------
							If (nY <> 1 .And. cAlias == cOldAlias)
								aOldDados := oSuperObjeto:GetData()
								For nX := 1 To Len(aOldDados)
									If aOldDados[nX][MODEL_DATA_UPDATE] .Or. (nOperation == MODEL_OPERATION_INSERT)
										If (cAlias)->(FieldPos(aOldDados[nX][MODEL_DATA_IDFIELD])) > 0
											(cAlias)->(FieldPut(FieldPos(aOldDados[nX][MODEL_DATA_IDFIELD]),aOldDados[nX][MODEL_DATA_VALUE]))
										EndIf
									EndIf
								Next nX						
							EndIf
						EndIf
						//--------------------------------------------------------------------
						//Efetua a gravacao do bloco de cÃ³digo de pos-validaÃ§Ã£o
						//--------------------------------------------------------------------
						(cAlias)->(Eval(bAfter,oObjeto,oObjeto:cID,cAlias))
					EndIf
					//--------------------------------------------------------------------
					//Seleciona o modelos em que este Ã© proprietÃ¡rio.
					//--------------------------------------------------------------------
					/*If nNextOper <> 0
					For nX := 1 To Len(aModel[MODEL_STRUCT_OWNER])
					ExFormCommit(aModel[MODEL_STRUCT_OWNER][nX],bBefore,bAfter,nNextOper,oObjeto)						
					Next nX
					EndIf*/
				Next nY


				aRet	:= {.T.,""}


			ELSE

				If oObjeto:ClassName()=="FWFORMGRID"
					//--------------------------------------------------------------------
					//Efetua a gravacao da estrutura FWFORMGRID
					//--------------------------------------------------------------------
					If !Empty(cAlias)
						For nY := 1 To Len(aDados)
							lLock     := .F.
							oObjeto:GoLine(nY)
							//--------------------------------------------------------------------
							//Verifica o tipo de atualicao ( Insert ou Update )
							//--------------------------------------------------------------------
							If aDados[nY][MODEL_GRID_ID] <> 0
								(cAlias)->(MsGoto(aDados[nY][MODEL_GRID_ID]))
								RecLock(cAlias,.F.)
								lLock     := .T.
							EndIf
							If lLock
								/*
								//--------------------------------------------------------------------
								//Seleciona o modelos em que este Ã© proprietÃ¡rio.
								//--------------------------------------------------------------------
								For nX := 1 To Len(aModel[MODEL_STRUCT_OWNER])
								ExFormCommit(aModel[MODEL_STRUCT_OWNER][nX],bBefore,bAfter,nNextOper,oObjeto)
								Next nX
								//--------------------------------------------------------------------
								//Executa o bloco de cÃ³digo de Pre-atualizaÃ§Ã£o
								//--------------------------------------------------------------------
								If !Empty(bBefore)
								(cAlias)->(Eval(bBefore,oObjeto,oObjeto:cID,cAlias))
								EndIf
								*/
								//--------------------------------------------------------------------
								//Efetua a gravacao dos campos                    
								//--------------------------------------------------------------------
								(cAlias)->(dbDelete())
								//--------------------------------------------------------------------
								//Efetua a gravacao do bloco de cÃ³digo de pos-validaÃ§Ã£o
								//--------------------------------------------------------------------
								(cAlias)->(Eval(bAfter,oObjeto,oObjeto:cID,cAlias))
							EndIf
						Next nY
					EndIf	
				EndIf		


				aRet	:= {.T.,""}
			ENDIF

		ELSEIF ALLTRIM(oModCabec:ClassName())  == "FWFORMFIELDS"
			aRet[2] := "FWFORMFIELDS nao implementada." 
		ENDIF
	ENDIF


Return(aRet)



/*/{Protheus.doc} PRELZZA
Pre-Validacao 
@author www.compila.com.br
@version 1.0
/*/
Static Function PRELZZA(oModel, nLine, cAction, cField)
	Local lRet 		:= .T.
	Local oModFull		:= oModel:GetModel()
	Local nOperation := oModel:GetOperation()
	Local oView

	cAction := ALLTRIM(cAction)

	oModel:LoadValue("Z08_CODIGO", oModFull:GetValue("Z08MASTER", "Z08_CODIGO"))
	oModel:LoadValue("Z08_ITEM", STRZERO(oModel:GetLine(),3))

	IF cAction == 'CANSETVALUE' .AND. (nOperation == MODEL_OPERATION_INSERT .OR. nOperation == MODEL_OPERATION_UPDATE) 

		IF EMPTY(oModel:GetValue("Z08_CODREF"))
			oView	:= FWViewActive()

			oModel:LoadValue("Z08_CODREF", oModFull:GetValue("Z08MASTER", "Z08_CODIGO"))

			/*
			oModel:LoadValue("Z08_CODCTR", oModFull:GetValue("Z08MASTER", "Z08_CODCTR"))
			//oModel:LoadValue("Z08_REVCTR", oModFull:GetValue("Z08MASTER", "Z08_REVCTR"))		
			oModel:LoadValue("Z08_REVCTR", ZA2->ZA2_REV)
			oModel:LoadValue("Z08_CODCLI", oModFull:GetValue("Z08MASTER", "Z08_CODCLI"))
			oModel:LoadValue("Z08_LOJA", oModFull:GetValue("Z08MASTER", "Z08_LOJA"))		
			oModel:LoadValue("Z08_UM", oModFull:GetValue("Z08MASTER", "Z08_UM"))

			//oModel:LoadValue("Z08_MANIF", oModFull:GetValue("Z08MASTER", "Z08_MANIF"))
			oModel:LoadValue("Z08_PLACA", oModFull:GetValue("Z08MASTER", "Z08_PLACA"))
			oModel:LoadValue("Z08_NOMMOT", oModFull:GetValue("Z08MASTER", "Z08_NOMMOT"))		
			oModel:LoadValue("Z08_DTENT", oModFull:GetValue("Z08MASTER", "Z08_DTENT"))
			oModel:LoadValue("Z08_HRENT", oModFull:GetValue("Z08MASTER", "Z08_HRENT"))		
			oModel:LoadValue("Z08_DTSAI", oModFull:GetValue("Z08MASTER", "Z08_DTSAI"))
			oModel:LoadValue("Z08_HRSAI", oModFull:GetValue("Z08MASTER", "Z08_HRSAI"))

			oModel:LoadValue("Z08_TIPCLI", oModFull:GetValue("Z08MASTER", "Z08_TIPCLI"))
			oModel:LoadValue("Z08_CODORI", ZA2->ZA2_CODORI)
			oModel:LoadValue("Z08_TARA", oModFull:GetValue("Z08MASTER", "Z08_TARA"))
			oModel:LoadValue("Z08_TRANSP", oModFull:GetValue("Z08MASTER", "Z08_TRANSP"))
			oModel:LoadValue("Z08_CODGER", oModFull:GetValue("Z08MASTER", "Z08_CODGER"))
			oModel:LoadValue("Z08_BALENT", oModFull:GetValue("Z08MASTER", "Z08_BALENT"))
			oModel:LoadValue("Z08_BALSAI", oModFull:GetValue("Z08MASTER", "Z08_BALSAI"))
			oModel:LoadValue("Z08_CODSET", oModFull:GetValue("Z08MASTER", "Z08_CODSET"))
			oModel:LoadValue("Z08_CODCIR", oModFull:GetValue("Z08MASTER", "Z08_CODCIR"))
			oModel:LoadValue("Z08_PSSAI", oModFull:GetValue("Z08MASTER", "Z08_TARA"))

			oModel:LoadValue("Z08_CODNAT", oModFull:GetValue("Z08MASTER", "Z08_CODNAT"))		
			oModel:LoadValue("Z08_LOTE", oModFull:GetValue("Z08MASTER", "Z08_LOTE"))
			oModel:LoadValue("Z08_COTA", oModFull:GetValue("Z08MASTER", "Z08_COTA"))

			IF lDesOper
			oModel:LoadValue("Z08_ORIREG", "2")
			ELSEIF lDesAmbi
			oModel:LoadValue("Z08_ORIREG", "4")		
			ENDIF

			oModel:LoadValue("Z08_OBS", "")
			*/
			oView:Refresh()
		ENDIF

	ELSEIF cAction == 'DELETE' //.AND.  EMPTY(oModel:GetValue("Z08_CODREF"))

		ROLLBACKSX8()

	ENDIF



Return(lRet)


/*/{Protheus.doc} CPOCABEC
(long_description)
@author Augusto Ribeiro | www.compila.com.br
@since 12/10/2017
@version version
@param param
@return return, return_description
@example
(examples)
@see (links_or_references)
/*/
Static Function CPOCABEC(cCampo)
	Local lRet	:= .F.

	Default cCampo	:= ""

	cCampo	:= ALLTRIM(cCampo)


	IF ASCAN(aCpoCabec, cCampo) > 0
		lRet	:= .T.
	ENDIF
	/*
	IF cCampo == "Z08_CODIGO" .OR.;
	cCampo == "Z08_DESC"

	lRet	:= .T.

	ENDIF

	*/


Return(lRet)




/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ CP01005G ºAutor  ³Augusto Ribeiro     º Data ³ 11/02/2011  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Retorna Conteudo do Pagametro solicitado                   º±±
±±º          ³                                                            º±±
±±ºPARAMETROS³ cTipoNF, cChave                                            º±±
±±ºRETORNO   ³ xRet | Formula                                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function CP01005G(cCodigo, cChvFunc)
	Local xRet

	DBSELECTAREA("Z08")
	Z08->(DBSETORDER(2))
	IF Z08->(DBSEEK(XFILIAL("Z08")+cCodigo+cChvFunc,.F.))
		xRet	:= &(Z08->Z08_FORMUL)
	ENDIF

Return(xRet)


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ CP01005D ºAutor  ³Augusto Ribeiro     º Data ³ 11/02/2011  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Inclui Valore Defaults                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function CP01005D()
	Local aDadosCad	:= {} 
	Local aDadosN	:= {}         
	Local aDadosZ08	:= {}
	Local cDesc10, cDesc11, cDesc12
	Local nI, nY, nX


	//	"<Codigo, Chave, Default, DESCTEC>"	


	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ DANFE - CONFIGURACOES GLOBAIS                                     ³
	//³ Parametros para importacao nota fiscal de entrada e saida vai XML ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cDesc10	:= "XML DANFE - Configurações Globais"
	aDadosCad	:= {}
	AADD(aDadosCad,{"10", "XMLTEMP"		,	'"\data_xml\temp\"'			,	"Pasta temporaria para processamento do xml"})
	AADD(aDadosCad,{"10", "XMLREJ"		,	'"\data_xml\rejeitado\"'	,	"Pasta para descarte dos arquivos rejeitados"})
	AADD(aDadosCad,{"10", "XMLPDF"		,	'"\data_xml\pdf\"'			,	"Pasta de destino dos arquivos PDF"})	 
	AADD(aDadosCad,{"10", "XMLVLD"		,	".T."						,	"Valida nfe automaticamente após pre-importação do arquivo"})	
	AADD(aDadosCad,{"10", "XMLENTRADA"	,	'.T.'						,	"Importa XML de Entrada"})		
	AADD(aDadosCad,{"10", "XMLSAIDA"	,	'.F.'						,	"Importa XML de Saida"})		
	AADD(aDadosCad,{"10", "VLDSEF"		,	'.F.'						,	"Valida XML no Sefaz"})		
	AADD(aDadosCad,{"10", "XMLAPI"		,	""		    				,	"Filiais para automatização API-Motor. SEPARAR CODIGO DA FILIAL POR | . "})		
	AADD(aDadosCad,{"10", "APITOKEN"	,	""		    				,	"Token para automatização API-Motor"})		

	aadd(aDadosN, {"10",cDesc10, aDadosCad})

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ DANFE - ENTRADA    ³
	//³ Parametros Defaults³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 
	cDesc11	:= "XML DANFE - ENTRADA"     
	aDadosCad	:= {}
	AADD(aDadosCad,{"11", "XMLOK"		,	'"\data_xml\importado_entrada\"', "Pasta de destino dos arquivos processados - ENTRADA"})
	AADD(aDadosCad,{"11", "XMLGPNF"		, 	".F."	 					,	"Gera Pre-Nota Automaticamente"} )
	AADD(aDadosCad,{"11", "XMLTPNF"		, 	'"SPED"' 					,	"Tipo de Nota ao Gerar Pre-Nota"})
	AADD(aDadosCad,{"11", "XMLTPCTE"	, 	'"CTR"'	 					,	"Tipo de Nota ao Gerar Cte"})
	AADD(aDadosCad,{"11", "CADFOR"		, 	'.T.'	 					,	"Habilita facilitador de cadastro de Fornecedor"})
	AADD(aDadosCad,{"11", "PEDPXF"		, 	'.F.'	 					,	"Cadastro de Produto X Fornecedor com base no Ped. Compra"})
	AADD(aDadosCad,{"11", "CADPXF"		, 	'.T.'	 					,	"Habilita facilitador de cadastro Produto X Fornecedor"})	
	AADD(aDadosCad,{"11", "DESTPNF"		, 	""		 					,	"Destinatarios a receber o Log da ger.  Pre-Nota Automatica a partir da XML"})	
	AADD(aDadosCad,{"11", "XMLEFIL"		, 	""		 					,	"Empresa Filial que permitem importação de XML Ex.: 0101/0102/0103/0304/ | Em branco = Todas as empresas e suas filiais"})
	AADD(aDadosCad,{"11", "WFNFMAN"		, 	""		 					,	"Destinatário para do email alerta inclusão Pre-nota manual"})
	AADD(aDadosCad,{"11", "WFNFCAN"		, 	""		 					,	"Destinatário para do email alerta NF Integrada e Cancelada"})
	AADD(aDadosCad,{"11", "XMLFTP"		, 	""		 					,	"Endereço FTP dos arquivos XML DANFE  - Origem"})
	AADD(aDadosCad,{"11", "XMLFUSR"		, 	""		 					,	"Usuário do FTP - XML Danfe"})
	AADD(aDadosCad,{"11", "XMLFPSW"		, 	""		 					,	"Senha do FTP - XML Danfe"})
	AADD(aDadosCad,{"11", "XMLFPOR"		, 	""		 					,	"Porta do FTP XML Danfe"})
	AADD(aDadosCad,{"11", "XMLFDIR"		, 	""		 					,	"Diretório do XML DANFE"})	
	AADD(aDadosCad,{"11", "CFBYPAS"		, 	""		 					,	"CFOPs que nao exige PC ao gerar pre-nota, Digitar  somente os 3 ultimos caracteres, separar com / Ex  Ex.: 102-118/120-125/130/144/152-180"})
	AADD(aDadosCad,{"11", "CONVCF1"		, 	""		 					,	'Converte CFOP 1 - Excecoes CFOP entrada para saída. Ex.: {{"de","para"}, {"101","123"}}'})
	AADD(aDadosCad,{"11", "CONVCF2"		, 	""		 					,	'Converte CFOP 1 - Excecoes CFOP entrada para saída. Ex.: {{"de","para"}, {"101","123"}}'})
	AADD(aDadosCad,{"11", "CFBENEF"		, 	""		 					,	"CFOPs de beneficiamento, Digitar  somente os 3 ultimos caracteres, separar com / Ex.: 102-118/120-125/130/144/152-180"})
	AADD(aDadosCad,{"11", "CFDEVOL"		, 	""		 					,	"CFOPs de devolucao, Digitar  somente os 3 ultimos caracteres, separar com / Ex.: 102-118/120-125/130/144/152-180"})	
	AADD(aDadosCad,{"11", "FORBYPAS"	, 	""		 					,	"Fornecedor By Pass no Pedido de Compra, Cod+Loja separado com / Ex.: 00000101/00023401 "})		
	AADD(aDadosCad,{"11", "NFXPC"		, 	".T." 	 					,	"Vincula NFe x Pedido Compra, (.F.=Nao; .T.=Sim)"})		
	AADD(aDadosCad,{"11", "NFXPCMODO"	, 	"2"   						,	"Metodo utilizado para amarração (1=Automatico (Pedidos mais antigos); 2=Informado pelo usuario)"})		
	AADD(aDadosCad,{"11", "NFXPCQTDE"	, 	".F." 						,	"Valida Quantidade ? .T. = Valida; .F. = Nao valida"})		
	AADD(aDadosCad,{"11", "NFXPCVLR"	,  	".F." 						,	"Valida Valor ? .T. = Valida; .F. = Nao valida"})		
	AADD(aDadosCad,{"11", "XMLPATHSRV"	, 	""							,	"Path do servidor para carga automatica dos arquivos."})	
	AADD(aDadosCad,{"11", "MAILSRVPOP"	, 	"pop.compila.com.br"		,	"URL servidor POP para download dos e-mails"})
	AADD(aDadosCad,{"11", "MAILLOGIN"	,  	"workflow@compila.com.br"	,	"Usuario para acesso ao e-mail"})
	AADD(aDadosCad,{"11", "MAILSENHA"	, 	""							,	"Senha e-mail para acesso ao e-mail"})    
	AADD(aDadosCad,{"11", "PATHAJUST"	, 	'"..\..\Protheus_data"'		,	"Path de Ajuste para funcao Salve Attach"})			
	AADD(aDadosCad,{"11", "GERADOCAUT"	, 	'.F.'						,	"Gera documento(Documento de Entrada) automaticamente"})
	AADD(aDadosCad,{"11", "CPAGPADRAO"	, 	""							,	"Condicao de Pagamento Padrao"})
	AADD(aDadosCad,{"11", "NATPADRAO"	, 	""							,	"Codigo da natureza Padrao"})		
	AADD(aDadosCad,{"11", "PRODTRANSP"	, 	'"TRANSPORTE"'				,	"Codigo do produto para geração de Cte"})
	AADD(aDadosCad,{"11", "PRODCLIFOR"	, 	".F."						,	"Cadastro de Produto com base no XML"})
	AADD(aDadosCad,{"11", "CFSRVBEN"	, 	""							,	"CFOP de servico de beneficiamento.Digitar  somente os 3 ultimos caracteres"})					
	AADD(aDadosCad,{"11", "PRSRVBEN"	, 	""							,	"Codigo Produto de servico de beneficiamento"})
	AADD(aDadosCad,{"11", "FRBENEF"		, 	""							,	"Fornecedor By Pass no Beneficiamento, Cod+Loja separado com / Ex.: 00000101/00023401 "})
	AADD(aDadosCad,{"11", "CFPRENOTA"	, 	""							,	"Gera Pre-Nota Automaticamente com base no CFOP. Digitar  somente os 3 ultimos caracteres, separar com / Ex  Ex.: 102-118/120-125/130/144/152-180"})
	AADD(aDadosCad,{"11", "LOTECONTR"	, 	".F."						,	"Permite avançar sem lote quando o produto(B1_RASTRO) estiver configurado? .T. ou .F."})
	AADD(aDadosCad,{"11", "ALTERAVLR"	, 	".T."						,	"Permite alterar valor e unidade na Manutencao de Itens? .T. ou .F."})
	AADD(aDadosCad,{"11", "NOTASPRE"	, 	".F."						,	"Gera Nota sem passar pela Pré-nota?"})
	AADD(aDadosCad,{"11", "CTEREMET"	, 	".F."						,	"Gera nota de CTe com o tomador do serviço no CT-e igual 3-Destinatário?"})
	AADD(aDadosCad,{"11", "TESPROD"		, 	".F."						,	"Atribui TES vinculada ao Produto?"})
	AADD(aDadosCad,{"11", "RETORNF   "	, 	".F."						,	"Utiliza padrão para retorno de NF?"})
	AADD(aDadosCad,{"11", "CFOPEXP   "	, 	"501"						,	"CFOP's para fins de Exportação. Digitar  somente os 3 ultimos caracteres, separar com / Ex.: 102-118/120-125/130/144/152-180"})

	aadd(aDadosN, {"11",cDesc11, aDadosCad})           

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ DANFE - SAIDA      ³
	//³ Parametros Defaults³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 
	cDesc12	:= "XML DANFE - SAIDA"      
	aDadosCad	:= {} 
	AADD(aDadosCad,{"12", "XMLGPNF"		, 	".F."							,	"Gera Pedido de Venda Automaticamente"} )	
	AADD(aDadosCad,{"12", "XMLOK"		,	'"\data_xml\importado_saida\"'	, 	"Pasta de destino dos arquivos processados - SAIDA"})
	AADD(aDadosCad,{"12", "XMLEFIL"		, 	""								,	"Empresa Filial que permitem importação de XML Ex.: 0101/0102/0103/0304/ | Em branco = Todas as empresas e suas filiais"})	
	AADD(aDadosCad,{"12", "CADCLI"		, 	'.T.'							,	"Habilita facilitador de cadastro de Clientes"})	
	AADD(aDadosCad,{"12", "CFBENEF"		, 	""								,	"CFOPs de beneficiamento, Digitar  somente os 3 ultimos caracteres, separar com / Ex.: 102-118/120-125/130/144/152-180"})
	AADD(aDadosCad,{"12", "CFDEVOL"		, 	""								,	"CFOPs de devolucao, Digitar  somente os 3 ultimos caracteres, separar com / Ex.: 102-118/120-125/130/144/152-180"})	
	AADD(aDadosCad,{"12", "GERADOCAUT"	, 	'.F.'							,	"Gera documento(Nota Fiscal e Saida) automaticamente"})	
	AADD(aDadosCad,{"12", "CPAGPADRAO"	, 	""								,	"Condicao de Pagamento Padrao"})
	AADD(aDadosCad,{"12", "CPAGTIPO9"	, 	""								,	"Condicao de Pagamento tipo nove - Necessario para geracao das parcelas conforme tag Cobr do XML"})			
	AADD(aDadosCad,{"12", "XMLLBPV"		, 	".T."							,	"Libera Pedido de Venda Automaticamente"})
	AADD(aDadosCad,{"12", "PRODCLIFOR"	, 	".F."							,	"Cadastro de Produto com base no XML"})				

	aadd(aDadosN, {"12",cDesc12, aDadosCad})    	


	DBSELECTAREA("Z08")              
	nTotCpo	:= FCOUNT()
	Z08->(DBSETORDER(2))             


	FOR nX := 1 TO LEN(aDadosN)    

		IF Z08->(DBSEEK(XFILIAL("Z08")+aDadosN[nX,1]))   
			cDesc11	:= Z08->Z08_DESC
		ELSE
			cDesc11  := aDadosN[nX,2]
		ENDIF	                    

		aDadosZ08 := aDadosN[nX,3]

		cCodConfig	:= aDadosN[nX,1]
		FOR nI := 1 to len(aDadosZ08)  

			IF Z08->(!DBSEEK(XFILIAL("Z08")+aDadosZ08[nI, 1]+aDadosZ08[nI, 2]))  

				RegToMemory("Z08",.T.)

				M->Z08_CODIGO	:= aDadosZ08[nI, 1]
				M->Z08_DESC		:= cDesc11
				M->Z08_ITEM		:= SOMA1( RetMaxItem(aDadosZ08[nI, 1]) )
				M->Z08_CHAVE	:= aDadosZ08[nI, 2]
				M->Z08_FORMUL	:= aDadosZ08[nI, 3]
				M->Z08_DESTEC 	:= aDadosZ08[nI, 4]

				RECLOCK("Z08",.T.)
				FOR nY := 1 to nTotCpo
					FieldPut(nY, M->&(FieldName(nY)))
				NEXT nY		     
				MSUNLOCK()    

			ENDIF
		NEXT  nI
	NEXT nX


Return()


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ RetMaxItemºAutor ³Augusto Ribeiro     º Data ³ 11/02/2011  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Retorna last item                                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function RetMaxItem(cCodigo)
	Local cRet 		:= ""
	Local cQuery	:= ""

	cQuery	+= " SELECT MAX(Z08_ITEM) AS Z08_ITEM "
	cQuery	+= " FROM "+RetSqlName("Z08")
	cQuery	+= " WHERE Z08_FILIAL = '' "
	cQuery	+= " AND Z08_CODIGO = '"+cCodigo+"' "
	cQuery	+= " AND D_E_L_E_T_ = '' "


	If Select("TITEM") > 0
		TITEM->(DbCloseArea())
	EndIf                

	cQuery	:= changeQuery(cQuery)         

	DBUseArea(.T.,"TOPCONN", TCGenQry(,,cQuery),"TITEM", .F., .T.)      	 


	IF TITEM->(!EOF()) 
		cRet	:= TITEM->Z08_ITEM
	ELSE
		cRet	:= "000"
	ENDIF

	TITEM->(DbCloseArea())

Return(cRet)



/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa   ³   C()   ³ Autores ³Jonatas Oliveira        ³ Data ³  /  /    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao  ³ Funcao responsavel por manter o Layout independente da       ³±±
±±³           ³ resolucao horizontal do Monitor do Usuario.                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function C(nTam)
	Local nHRes := oMainWnd:nClientWidth // Resolucao horizontal do monitor
	If nHRes == 640 // Resolucao 640x480 (soh o Ocean e o Classic aceitam 640)
		nTam *= 0.8
	ElseIf (nHRes == 798).Or.(nHRes == 800) // Resolucao 800x600
		nTam *= 1
	Else // Resolucao 1024x768 e acima
		nTam *= 3.50
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Tratamento para tema "Flat"³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	If (Alltrim(GetTheme()) == "FLAT") .Or. SetMdiChild()
		nTam *= 0.90
	EndIf

Return Int(nTam)


