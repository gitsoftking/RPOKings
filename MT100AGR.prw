#INCLUDE "TOTVS.CH"
#INCLUDE "Protheus.ch"
#INCLUDE "RWMAKE.ch"

/*
+------------+----------+-------+----------------------+------+----------------+
| Programa   |MT100AGR  | Autor | geovani.figueira     | Data | junho/2018     |
+------------+----------+-------+----------------------+------+----------------+
| Descricao  | Funcionalidades em notas fiscais de entrada                     |
+------------+-----------------------------------------------------------------+
| Uso        | GDC						                                       |
+------------+-----------------------------------------------------------------+
*/// Integracao Paradigma
User Function MT100AGR()

Local a_AreaATU	:= GetArea()
Local a_AreaSD1	:= SD1->(GetArea())
Local a_AreaSC7	:= SC7->(GetArea())
Local lImpNFE := GetMv("MV_XMLIMP",.F.,.F.) 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Utiliza sistema de importacao de XML ? ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
IF  lImpNFE
	fAltStXML()
ENDIF 

If ( cEmpAnt == '03' )

	dbSelectArea('SD1')
	dbSetOrder(1)	// D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_COD+D1_ITEM
	dbSeek(xFilial('SD1')+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA)

	While SD1->(!EOF()) .And. xFilial('SD1')  == SF1->F1_FILIAL  .And. SD1->D1_DOC  == SF1->F1_DOC .And. SD1->D1_SERIE == SF1->F1_SERIE ;
						.And. SD1->D1_FORNECE == SF1->F1_FORNECE .And. SD1->D1_LOJA == SF1->F1_LOJA
		dbSelectArea('SC7')
		SC7->(dbSetOrder(1))
		If dbSeek(xFilial('SD1')+SD1->D1_PEDIDO+SD1->D1_ITEMPC) .And. (SC7->C7_XINTPAR == '1')
			SC7->(RecLock('SC7',.F.))
			SC7->C7_XDTPAR := CtoD("//")
			SC7->(MsUnLock())
		EndIf
		SD1->(DbSkip())
	EndDo

EndIf

RestArea(a_AreaSC7)
RestArea(a_AreaSD1)
RestArea(a_AreaATU)

Return Nil

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÝÝÝÝÝÝÝÝÝÝÑÝÝÝÝÝÝÝÝÝÝËÝÝÝÝÝÝÝÑÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝËÝÝÝÝÝÝÑÝÝÝÝÝÝÝÝÝÝÝÝÝ»±±
±±ºPrograma  ³ fAltStXMLºAutor  ³ Augusto Ribeiro	 º Data ³  27/04/2012 º±±
±±ÌÝÝÝÝÝÝÝÝÝÝØÝÝÝÝÝÝÝÝÝÝÊÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÊÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ¹±±
±±ºDesc.     ³ IMPORTA NF-e | Altera status no painel de arquivos         º±±
±±º          ³                                                            º±±
±±ÈÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function fAltStXML()
Local aArea := GetArea()
                               

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inclusao de Nota Fiscal ou Classificacao ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
IF !EMPTY(SF1->F1_CHVNFE)
	IF INCLUI .OR. ALTERA
		
		aAreaZ10	:= Z10->(GetArea())
		                
		DBSELECTAREA("Z10")
		Z10->(DBSETORDER(1))	//| Z10_FILIAL, Z10_CHVNFE
		IF Z10->(DBSEEK(XFILIAL("Z10")+SF1->F1_CHVNFE+"E",.F.))
		    
			RECLOCK("Z10",.F.)
				Z10->Z10_STATUS	:= "5"	
				Z10->Z10_DTSE := CtoD("//")	
			MSUNLOCK()
		ENDIF
		  
		RestArea(aAreaZ10)	
	
		
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Exclusao ou estorno de classificacao da Nota �
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	ELSEIF !INCLUI .AND. !ALTERA
	       
		aAreaZ10	:= Z10->(GetArea())
		                
		DbSelectArea('SD1')
		SD1->(DbSetOrder(1))	// D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_COD+D1_ITEM						

		DBSELECTAREA("Z10")
		Z10->(DBSETORDER(1))	//| Z10_FILIAL, Z10_CHVNFE
		IF Z10->(DBSEEK(XFILIAL("Z10")+SF1->F1_CHVNFE+"E",.F.))		

			RECLOCK("Z10",.F.)
				If SD1->(dbSeek(xFilial('SD1')+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA))
					Z10->Z10_STATUS	:= "2" //Estorno de classificacao
				Else 
					Z10->Z10_STATUS	:= "1" //Exclusao da NF
				EndIf
				Z10->Z10_DTSE 	:= CtoD("//")	
				Z10->Z10_IDSE	:= ""	
				Z10->Z10_LOGINT := ""		
			MSUNLOCK()
		
			/*----------------------------------------
				30/04/2019 - Jonatas Oliveira - Compila
				Atualiza Motor Fiscal
			------------------------------------------*/
			U_CP01MFST(Z10->Z10_CNPJ, Z10->Z10_CHVNFE, "INTEGRADO", IIF( ALLTRIM(Z10->Z10_TIPARQ) == "C", "CTE", "NFE" ))
		
		
		ELSEIF Z10->(DBSEEK(XFILIAL("Z10")+SF1->F1_CHVNFE+"C",.F.))
		    
			RECLOCK("Z10",.F.)
				If SD1->(dbSeek(xFilial('SD1')+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA))
					Z10->Z10_STATUS	:= "2" //Estorno de classificacao
				Else 
					Z10->Z10_STATUS	:= "1" //Exclusao da NF
				EndIf
				Z10->Z10_DTSE 	:= CtoD("//")	
				Z10->Z10_IDSE	:= ""	
				Z10->Z10_LOGINT := ""		
			MSUNLOCK()		

			/*----------------------------------------
				30/04/2019 - Jonatas Oliveira - Compila
				Atualiza Motor Fiscal
			------------------------------------------*/
			U_CP01MFST(Z10->Z10_CNPJ, Z10->Z10_CHVNFE, "INTEGRADO", IIF( ALLTRIM(Z10->Z10_TIPARQ) == "C", "CTE", "NFE" ))
							
		ENDIF
		  
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Remove campo SYP caso exista dados  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

		IF !EMPTY(SF1->F1_XCNFOBS)
			MSMM(SF1->F1_XCNFOBS,,,,2,,,"SF1","F1_XCNFOBS")
		ENDIF
			
		RestArea(aAreaZ10)	

		IF !EMPTY(SF1->F1_XCNFOBS)	
			MSMM(SF1->F1_XCNFOBS,,,,2,,,"SF1","F1_XCNFOBS")	
		ENDIF
		      
	
	ENDIF 
ENDIF
      
RestArea(aArea)
Return()