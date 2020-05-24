#INCLUDE "PROTHEUS.ch"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄ»±±
±±³Programa  ³ MT103FIM ³ Autor ³ Felipe Lima de Aguiar³Data  ³	09/04/12    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³  ID Chamado: 16914											³±±
±±³			 ³	P.E. responsavel por gravar a chave NFE(F2_CHVNFE)da nota   ³±±
±±³			 ³	de saida na nota de entrada para transferencias.            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico GDC Alimentos                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Analista Resp.³  Data  ³ Manutencao Efetuada                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Renato Freire ³ Cha 26499: Ajuste gravacao do campo Chave de Acesso NF-e ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Felipe Reis   ³ Cha 37145: Ajuste finalizar Pedido de compra.            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Felipe Reis   ³24/11/15³ Ajustes para Integragracao do WMS.              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Felipe Reis   ³15/12/15³ Executa rotina de importacao de reservas do WMS ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Daniel Ciriano³29/01/16³ CHAMADO 59761 - Tratativa para notas do tipo B  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Felipe Reis   ³12/01/16³ 3a Fase do projeto de Rastreabilidade.          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Ewerton H. Coz³22/03/16³ CHAMADO 61032 - Envia E-mail, qndo NF for clas- ³±±
±±³				 ³        ³ sificada sem o nro da chave NFE chama a funcao  ³±±
±±³              ³        ³ fSndNFSmChv                                     ³±± 
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Michael Castro³06/04/16³ Chamado 61474 - Michael Castro (Tipos de Especie³±±
±±³              ³        ³ que podem enviar email de notificação caso o    ³±±
±±³              ³        ³ campo F1_CHVNFE estiver em branco) foi criado o ³±±
±±³              ³        ³ PARAMETRO [MV_XESPNFE] para não precisar incluir³±±
±±³              ³        ³ novos tipos de especie que necessitem de        ³±±
±±³              ³        ³ validação         								³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Flavio V.     ³14/04/16³ Chamado 59256: Envia e-mail aos responsaveis    ³±±
±±³              ³        ³ quando a NF de Origem Informada na classificacao³±± 
±±³              ³        ³ da Pre-Nota de Entrada for diferente da         ³±±
±±³              ³        ³ informada na NF de Saida CFOP 5906.             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Felipe Reis   ³13/10/16³ Chamado 64759 - Atualizacao da mensagem do PCF. ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Felipe Reis   ³28/10/16³ Chamado 64960 - Ajuste da data da quarentena.   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Daniel Ciriano³21/02/17³ Chamado 67322 - Ajuste Integração GKO           ³±±
±±³              ³        ³ ao Classificar Nota de devolução.               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Felipe Reis   ³19/02/18³ Chamado 74319 - Transito retorno Fisico.        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß/*/                            
User Function MT103FIM()

	//CH 74524 - LOG
	Local a_VarsLog	:= {MsDate(), Time(), ""} //[1]-Data; [2]-Hora; [3]-Observacao

	Local c_FilOri    := ""
	Local c_Chave     := ""
	Local a_AreaSM0   := SM0->(GetArea())
	Local a_AreaSF1   := SF1->(GetArea())
	Local a_AreaSD1   := SD1->(GetArea())
	Local c_ChvSf2    := SF1->F1_DOC+SF1->F1_SERIE+AllTrim(SF1->F1_FORNECE)
	Local l_EhClassif := Type( "l_Classif" ) <> "U" .AND. l_Classif
	Local l_NaoEhClas := Type( "l_Classif" ) <> "U" .AND. !l_Classif
	Local nOpc        := PARAMIXB[1]
	Local nConfirma   := PARAMIXB[2]
	Local a_Pedido    := {}
	Local c_BDPCF     := ""
	Local c_FilOrig   := "" //declaracao dessa variavel
	Local c_UpdPCF    := ""
	Local l_MsgErro   := .F. //Apresentou a msg de não ter encontrada a chv nfe?
	Local l_ChvNInf   := .F. //Chave NFE em branco?
	Local c_FilSF2    := ""
	Local c_LjClie    := ""
	Local a_Divergs   := {}
	Local c_FornLj	  := ""
	
	Local nOpcao 	:= PARAMIXB[1]   // Opção Escolhida pelo usuario no aRotina   //| IMPORDOR XML COMPILA|
	Local lImpNFE 	:= GetMv("MV_XMLIMP",.F.,.F.)	 //| IMPORDOR XML COMPILA|
	Local _aArea	:=	GetArea() //| IMPORDOR XML COMPILA|
	
	Private n_Tipo		:= nOpc
	Private c_TipoAmb	:= Upper(AllTrim(GetSrvProfString("TipoAmbienteGDC", "TESTE"))) //Se não encontrar a chave, considera que é um ambiente de Teste
                                                                      
	l103Auto := IF(Type("l103Auto") == "U", .F., l103Auto)

	/*--------------------------
		IMPORDOR XML COMPILA
	---------------------------*/
	IF lImpNFE
	  	DBSELECTAREA("Z10")
		Z10->(DBSETORDER(1))	//| Z10_FILIAL, Z10_CHVNFE
		IF Z10->(DBSEEK(XFILIAL("Z10")+SF1->F1_CHVNFE+"E",.F.))
			IF nOpcao == 4 //|Classificação|
			
				/*----------------------------------------
				30/04/2019 - Jonatas Oliveira - Compila
				Atualiza Motor Fiscal
				------------------------------------------*/
				U_CP01MFST(Z10->Z10_CNPJ, Z10->Z10_CHVNFE, "NOTA CLASSIFICADA", IIF( ALLTRIM(Z10->Z10_TIPARQ) == "C", "CTE", "NFE" ))
			ELSEIF 	nOpcao == 5 //|Exclusão|
			
				/*----------------------------------------
				30/04/2019 - Jonatas Oliveira - Compila
				Atualiza Motor Fiscal
				------------------------------------------*/
				U_CP01MFST(Z10->Z10_CNPJ, Z10->Z10_CHVNFE, "INTEGRADO", IIF( ALLTRIM(Z10->Z10_TIPARQ) == "C", "CTE", "NFE" ))
				
			ENDIF
		ENDIF
		
	 EndIF
	 RestArea(_aArea)


//***************************************************************
//*Tratamento Natureza para quando for tipo de Devolução        *
//*e do tipo VENDAS no GRUPO CONTABIL da TES                    *
//*                                                             *
//*Chamado Nº#59418 - Luiza e Jeferson                          *
//*                                                             *
//***************************************************************
	If (SF1->F1_TIPO == "D")
	
		aArea_SE1 := SE1->(GetArea())
		aArea_SD1 := SD1->(GetArea())
		l_Naturez := .F.
		
	//Posiciona no primeiro item da nota
		dbSelectArea("SD1")
		SD1->(dbSetOrder(1))//D1_FILIAL, D1_DOC, D1_SERIE, D1_FORNECE, D1_LOJA, D1_COD, D1_ITEM, R_E_C_N_O_, D_E_L_E_T_
		SD1->(dbGoTop())
		SD1->(dbSeek(SF1->(F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA)))
	
	//Somente Produtos que são controlados pelo WMS		
		While SD1->(!Eof()) .And. SF1->(F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA) == SD1->(D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA) .And. !l_Naturez
		
			If GetAdvFVal("SF4","F4_GRCTB",xFilial("SF4")+SD1->D1_TES,1,"") $ "C3A/C3B"
        
				l_Naturez := .T. // Verifica se um item já possui GRUPO CONTABIL de DEVOLUÇÃO de VENDAS
		
				c_Query := " UPDATE "+RetSqlName("SE1")+" SET E1_NATUREZ = '"+AllTrim(GetMv("MV_DEVNATU"))+"' "
				c_Query += " WHERE D_E_L_E_T_ = '' "
				c_Query += "   AND E1_FILORIG = '"+SF1->F1_FILIAL+"' AND E1_NUM = '"+SF1->F1_DOC+"' AND E1_SERIE = '"+SF1->F1_SERIE+"' AND E1_CLIENTE = '"+SF1->F1_FORNECE+"' AND E1_LOJA = '"+SF1->F1_LOJA+"' "
				c_Query += "   AND E1_ORIGEM = 'MATA100' "
	        
				TCSQLExec(c_Query)

			EndIf
		
			SD1->(dbSkip())
		EndDo
	
		RestArea(aArea_SE1)
		RestArea(aArea_SD1)
	
	EndIf

//Envia email para com os titulos a serem compensados com a nota inserida.
	If (SM0->M0_CODIGO == '03')
		fEnvMail()
	EndIf

//Atualizacoes nas tabelas do PC-Factory
	If !(l103Auto)

		//Trata tabela do ambiente de PRODUCAO e ambiente TESTE do PC-Factory, pois eles estao no mesmo BD.
		If ( c_TipoAmb == "PRODUCAO" )
			c_BDPCF := GetMv("MV_XINPCFP")
		Else
			c_BDPCF := GetMv("MV_XINPCFT")
		EndIf
		     
		If !Empty(SF1->F1_DOC)
		          
		//Atualiza status do consumo no PC-Factory           
			TCSqlExec("UPDATE "+c_BDPCF+".dbo.TBLOutInteg SET Integrated = 0, IDTransactions = '' WHERE MovTypeCode in ('055','555') and IDTransactions LIKE '" + AllTrim(SF1->F1_FILIAL) + AllTrim(SF1->F1_DOC) + AllTrim(SF1->F1_SERIE) + AllTrim(SF1->F1_FORNECE) + AllTrim(SF1->F1_LOJA)+"%'")
		
		EndIf
	 
	//Classificacao de pre nota - Atualiza informacoes do PC-Factory com o Status de Processado
		If l_EhClassif .And. SF1->F1_XEXPPCF == "2" .And. nOpc == 4 .And. nConfirma == 1 .And. AllTrim(FunName()) == "MATA103"
			c_UpdPCF := "UPDATE "+c_BDPCF+".dbo.TBLOutInteg SET Integrated = 2 "
			c_UpdPCF += "WHERE MovTypeCode in ('002','502') "
			c_UpdPCF += "AND Integrated = 0 "
			c_UpdPCF += "AND AuxField1 = '"+SF1->F1_DOC+"' + '/' + '"+IIf(Empty(SF1->F1_SERIE),"XXX",SF1->F1_SERIE)+"' "
			c_UpdPCF += "AND CompanyCode = '"+SF1->F1_FORNECE+"' + '"+SF1->F1_LOJA+"' "
		
			If TCSQLExec(c_UpdPCF) < 0
				MsgAlert("Atualização da classificao no PC-Factory não realizada! NF "+SF1->F1_DOC+" Serie "+SF1->F1_SERIE+" Fornecedor "+SF1->F1_FORNECE+"/"+SF1->F1_LOJA+". Em breve será atualizado automaticamente.")
			EndIf
		EndIf
	
	//Estorno de classificacao - Atualiza informacoes do PC-Factory com o Status de nao Processado
		If l_NaoEhClas .And. SF1->F1_XEXPPCF == "2" .And. nOpc == 5 .And. nConfirma == 1 //.And. AllTrim(FunName()) == "MATA140"
			c_UpdPCF := "UPDATE "+c_BDPCF+".dbo.TBLOutInteg SET Integrated = 0 "
            If SF1->F1_FORMUL == "S"
                c_UpdPCF += ", Ext1Integrated = 0"
            EndIf
			c_UpdPCF += "WHERE MovTypeCode in ('002','502') "
			c_UpdPCF += "AND Integrated = 2 "
			c_UpdPCF += "AND AuxField1 = '"+SF1->F1_DOC+"' + '/' + '"+IIf(Empty(SF1->F1_SERIE),"XXX",SF1->F1_SERIE)+"' "
			c_UpdPCF += "AND CompanyCode = '"+SF1->F1_FORNECE+"' + '"+SF1->F1_LOJA+"' "
		
			If TCSQLExec(c_UpdPCF) < 0
				MsgAlert("Atualização do Estorno no PC-Factory não realizada! NF "+SF1->F1_DOC+" Serie "+SF1->F1_SERIE+" Fornecedor "+SF1->F1_FORNECE+"/"+SF1->F1_LOJA+". Em breve será atualizado automaticamente.")
			EndIf
		EndIf
	
	//Inclusao de NF com bloqueio de movimento - Envia dados nota para o PC-Factory
		If nOpc == 3 .And. nConfirma == 1 .And. AllTrim(FunName()) == "MATA103" .And. MV_PAR17 <> 2
			U_ExpNFEPCF({SF1->F1_DOC, IIf(Empty(SF1->F1_SERIE),"XXX",SF1->F1_SERIE), SF1->F1_FORNECE, SF1->F1_LOJA, '1', SF1->F1_FILIAL})
		EndIf
	
	//Exclusao de NF com bloqueio de movimento - Envia dados de exclusao da nota para o PC-Factory
		If nOpc == 5 .And. nConfirma == 1 .And. AllTrim(FunName()) == "MATA103" .And. !Empty(SF1->F1_XEXPPCF)
			U_ExpNFEPCF({SF1->F1_DOC, IIf(Empty(SF1->F1_SERIE),"XXX",SF1->F1_SERIE), SF1->F1_FORNECE, SF1->F1_LOJA, '2', SF1->F1_FILIAL})
		EndIf
		
	//Deixa pendente de aprovacao NF com bloqueio de movimento 
		If (nOpc == 3 .Or. nOpc == 4) .And. nConfirma == 1 .And. AllTrim(FunName()) == "MATA103" .And. MV_PAR17 <> 2
			u_AtuNFApv()
		EndIf
	
	EndIf
    // #67322 - GERA O TXT DE INTEGRAÇÃO NO GKO P/DEVOLUÇÃO -(nOpc == 3 INCLUIR; nOpc == 4 CLASSIFICAR)                                                
	If SF1->F1_FORMUL <> "S" .And. SF1->F1_TIPO == "D" .And. (nOpc == 3 .OR. nOpc == 4) .And. nConfirma == 1
		U_GKOG009(SF1->F1_DOC, SF1->F1_SERIE, SF1->F1_FORNECE, SF1->F1_LOJA, "")
	EndIf

//Verifica Origem TOTVS Colaboração e acerta tabela SFT                                                                  
	fManutCF()
//Verifico se eh nf de transf., se clicou em cancelar, se nao esta na empresa 03 ou nao eh classificar nao rodo o P.E.
	If ( SF1->F1_FORNECE <> "999999" .OR. nConfirma <> 1 .OR. SM0->M0_CODIGO <> '03' )
		//Provisorio para nao aparecer a tela de CNPJ 2x - Ch.89041
		If Type("l_UNQNF") <> "U" 
			l_UNQNF := .F.
		EndIf
		
		Return Nil
	Endif

	If ( l_NaoEhClas )

	//*************  Cintia Araujo - 06/2015 - Inicio -
	//Sendo Nf de Transferencia (cliente/fornecedor = 999999, verifico controle de reservas, para realizar o estorno da classificacao
		If ( AllTrim(FunName()) == "MATA140" )
	  
			c_FilOrig := SF1->F1_FILIAL
		                                     
		//Localizo qual e a filial de destino
			a_AreaSM0 := SM0->(GetArea())
			dbSelectArea("SX5")
			dbSetOrder(1)
			dbSeek(xFilial("SX5")+"ZD", .F.)
			While SX5->(!Eof()) .and. SX5->(X5_FILIAL+X5_TABELA) == xFilial("SX5")+"ZD"
				If  SUBSTRING(X5_CHAVE,4,2)  == SF1->F1_LOJA .And. Left(SX5->X5_CHAVE, 1) == "C"
					c_FilOrig := AllTrim(SX5->X5_DESCRI)
					Exit
				Endif
				SX5->(dbSkip())
			EndDo
			RestArea(a_AreaSM0)
		
		//Localizo qual e a loja de origem
			a_AreaSM0 := SM0->(GetArea())
			dbSelectArea("SX5")
			dbSetOrder(1)
			dbSeek(xFilial("SX5")+"ZD", .F.)
			While SX5->(!Eof()) .and. SX5->(X5_FILIAL+X5_TABELA) == xFilial("SX5")+"ZD"
				If AllTrim(SX5->X5_DESCRI) == cFilAnt .And. Left(SX5->X5_CHAVE, 1) == "F"
					c_LojaOrig := SUBSTRING(X5_CHAVE,4,2)
					Exit
				Endif
				SX5->(dbSkip())
			EndDo
			RestArea(a_AreaSM0)
		
		//Verifico se o pedido foi gerado pel transferencia   
			lPedTranf := .F.
		
			DbSelectArea("SD2")
			SD2->(DbSetOrder(3))
			If SD2->(DbSeek(c_FilOrig + SD1->D1_DOC + SD1->D1_SERIE + SD1->D1_FORNECE + c_LojaOrig + SD1->D1_COD ))
				DbSelectArea("SC5")
				SC5->(DbSetOrder(1))
				If SC5->(DbSeek(c_FilOrig + SD2->D2_PEDIDO)) .And. SC5->C5_XPVNP3 = "S"
					lPedTranf := .T.
				EndIf
			EndIf
		
			If ( lPedTranf == .T. )
				aArea_SF1 := SD2->(GetArea())
				aArea_SF2 := SD2->(GetArea())
				aArea_SD1 := SD2->(GetArea())
				aArea_SD2 := SD1->(GetArea())
				aArea_SC6 := SC6->(GetArea())
			
				aItens    := {}
				aItPed    := {}
				c_NumRes  := ""
				c_TipRes  := ""
			
				DbSelectArea("SC6")
				SC6->(DbSetOrder(1)) //C6_FILIAL, C6_NUM, C6_ITEM, C6_PRODUTO, R_E_C_N_O_, D_E_L_E_T_
			
				DbSelectArea("SC0")
				SC0->(DbSetOrder(3)) //C0_FILIAL, C0_XCHVPED, R_E_C_N_O_, D_E_L_E_T_
			
				DbSelectArea("SD2")
				SD2->(DbSetOrder(3)) //D2_FILIAL, D2_DOC, D2_SERIE, D2_CLIENTE, D2_LOJA, D2_COD, D2_ITEM, R_E_C_N_O_, D_E_L_E_T_
			
				DbSelectArea("SF2")
				SF2->(DbSetOrder(1)) //F2_FILIAL, F2_DOC, F2_SERIE, F2_CLIENTE, F2_LOJA, F2_FORMUL, F2_TIPO, R_E_C_N_O_, D_E_L_E_T_
				SF2->(DbSeek(c_FilOrig + SF1->F1_DOC + SF1->F1_SERIE + SF1->F1_FORNECE + c_LojaOrig    ))
			
				DbSelectArea("SD1")
				SD1->(DbSetOrder(1)) //D1_FILIAL, D1_DOC, D1_SERIE, D1_FORNECE, D1_LOJA, D1_COD, D1_ITEM, R_E_C_N_O_, D_E_L_E_T_
				SD1->(DbSeek(xFilial("SD1")+SF1->(F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA) ))
			
				c_NumPV   := SD1->D1_DOC+SD1->D1_SERIE
				c_NumNF   := SD1->D1_DOC
			
				While SD1->(!EOF()) .and. SF1->(F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA) == SD1->(D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA)
					If SD2->(DbSeek(c_FilOrig + SD1->D1_DOC + SD1->D1_SERIE + SD1->D1_FORNECE + c_LojaOrig + SD1->D1_COD )) //+ SD1->D1_ITEM ))
						If SC6->(DbSeek(c_FilOrig + SD2->D2_PEDIDO + SD2->D2_ITEMPV + SD2->D2_COD ))
							If SC6->C6_XRETIDO == "1"
								c_TipRes := "04"
							ElseIf SC6->C6_XQUAREN == "1"
								c_TipRes := "03"
							Else
								c_TipRes := ""
							EndIf
						
						//  ***************** Retorno registro Reserva em transito
							Set Dele Off
						
							SC0->(DbSeek( c_FilOrig + SD2->D2_DOC + SD2->D2_SERIE + SD2->D2_ITEM, .F. ))
							While ( SC0->(!Eof()) .And. SC0->(C0_FILIAL+AllTrim(C0_XCHVPED)) == c_FilOrig+AllTrim(SD2->(D2_DOC+D2_SERIE+D2_ITEM)) )
							
								If ( SC0->C0_XTPPOD3 == "02" )
									RecLock("SC0", .F.)
									SC0->C0_QUANT   := SD2->D2_QUANT
									SC0->C0_XDATALT := Date()
									SC0->C0_XHORAA  := Left(Time(),5)
									SC0->(DbRecall())
									SC0->(MsUnLock())
								
									SB2->(DbSetOrder(1))
									If SB2->(DbSeek(c_FilOrig + SD2->D2_COD + SD2->D2_LOCAL, .F. ))
										RecLock("SB2", .F.)
										SB2->B2_RESERVA += SD2->D2_QUANT
										MsUnLock()
									EndIf
								EndIf
	
								SC0->(DbSkip())
	
							End
						
							Set Dele On
						
							If !Empty(c_TipRes) .And. SF1->F1_FILIAL == "20"

							//  ***************** Exclui Reserva em Quarentena ou Retido
								SC0->(DbSeek( c_FilOrig + SD1->(D1_DOC+D1_SERIE+D1_ITEM), .F. ))
							
								While ( SC0->(!Eof()) .And. SC0->(C0_FILIAL+AllTrim(C0_XCHVPED)) == c_FilOrig + AllTrim(SD1->(D1_DOC+D1_SERIE+D1_ITEM)) )

									If ( SC0->C0_XTPPOD3 == c_TipRes )
										SB2->(DbSetOrder(1))
										If SB2->(DbSeek(SC0->(C0_FILIAL+C0_PRODUTO+C0_LOCAL), .F.))
											RecLock("SB2", .F.)
											SB2->B2_RESERVA -= SC0->C0_QUANT
											MsUnLock()
										EndIf
									
										RecLock("SC0", .F.)
									//SC0->C0_QUANT := SD2->D2_QUANT
										SC0->(DbDelete())
										SC0->(MsUnLock())
									Endif
																
									SC0->(DbSkip())
								Enddo
				
							EndIf
						EndIf
					EndIf
				
					SD1->(dbSkip())
				End
			
				RestArea(aArea_SC6)
				RestArea(aArea_SF1)
				RestArea(aArea_SD1)
				RestArea(aArea_SF2)
				RestArea(aArea_SD2)
			EndIf
	
			//Exclui a reserva em transito na transferencia de retorno para filial de origem (AVARIA, CQ, etc..)
			If SD1->D1_FORNECE == "999999"
			
				aArea_SD1 := SD1->(GetArea())
			
				DbSelectArea("SD1")
				SD1->(DbSetOrder(1))
				SD1->(DbSeek(xFilial("SD1")+SF1->(F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA) ))
				
				While SD1->(!EOF()) .and. SF1->(F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA) == SD1->(D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA)
			
					Set Dele Off //Habilita os deletados
			
					DbSelectArea("SC0")
					SC0->(DbSetOrder(3))
					If SC0->(DbSeek( SD1->D1_FILIAL + "TF" + SD1->(D1_DOC + D1_SERIE + D1_ITEM)))
						
						If SD1->D1_FILIAL == "05" .And. SD1->D1_LOJA == "20" //Filial 11
							c_FornLj := "F5" 
						ElseIf SD1->D1_FILIAL == "05" .And. SD1->D1_LOJA == "23" //Filial 20
							c_FornLj := "F6" 
						ElseIf SD1->D1_FILIAL == "20" .And. SD1->D1_LOJA == "20" //Filial 11
							c_FornLj := "F2"
						EndIf
						
						RecLock("SC0", .F.)
						SC0->C0_QUANT   := SD1->D1_QUANT
						SC0->C0_XDATALT := Date()
						SC0->C0_XHORAA  := Left(Time(),5)
						SC0->(DbRecall())
						SC0->(MsUnLock())
					
						SB2->(DbSetOrder(1))
						If SB2->(DbSeek(SD1->(D1_FILIAL + SD1->D1_COD) + c_FornLj ))
							RecLock("SB2",.F.)
							SB2->B2_RESERVA += SD1->D1_QUANT
							MsUnLock()
						EndIf
						
					EndIf
					
					Set Dele On
					
					SD1->(DbSkip())
					
				EndDo	
				
				RestArea(aArea_SD1)
				
			EndIf			
		
		EndIf
	//*************  Cintia Araujo - 06/2015 - Fim -
	
	EndIf
         
//*************  Cintia Araujo - 06/2015 - Inicio -
	If ( l_EhClassif )

	//Localizo qual e a filial de destino
		a_AreaSM0 := SM0->(GetArea())
		dbSelectArea("SX5")
		dbSetOrder(1)
		dbSeek(xFilial("SX5")+"ZD", .F.)
		While SX5->(!Eof()) .and. SX5->(X5_FILIAL+X5_TABELA) == xFilial("SX5")+"ZD"
			If SubStr(SX5->X5_CHAVE, 4, 2) == SF1->F1_LOJA .And. Left(SX5->X5_CHAVE, 1) == "C"
				c_FilOrig := AllTrim(SX5->X5_DESCRI)
				Exit
			Endif
			SX5->(dbSkip())
		EndDo
		RestArea(a_AreaSM0)
	
	//Localizo qual e a loja de origem
		a_AreaSM0 := SM0->(GetArea())
		dbSelectArea("SX5")
		dbSetOrder(1)
		dbSeek(xFilial("SX5")+"ZD", .F.)
		While SX5->(!Eof()) .and. SX5->(X5_FILIAL+X5_TABELA) == xFilial("SX5")+"ZD"
			If AllTrim(SX5->X5_DESCRI) == cFilAnt .And. Left(SX5->X5_CHAVE, 1) == "F"
				c_LojaOrig := SUBSTRING(X5_CHAVE,4,2)
				Exit
			Endif
			SX5->(dbSkip())
		EndDo
		RestArea(a_AreaSM0)
	
	//Verifico se o pedido foi gerado pel transferencia   
		lPedTranf := .F.
	                                     
		DbSelectArea("SD2")
		SD2->(DbSetOrder(3))
		If SD2->(DbSeek(c_FilOrig + SD1->D1_DOC + SD1->D1_SERIE + SD1->D1_FORNECE + c_LojaOrig + SD1->D1_COD ))
			DbSelectArea("SC5")
			SC5->(DbSetOrder(1))
			If SC5->(DbSeek(c_FilOrig + SD2->D2_PEDIDO)) .And. SC5->C5_XPVNP3 = "S"
				lPedTranf := .T.
			EndIf
		EndIf
	
		If ( lPedTranf == .T. )
		
			aArea_SF1 := SF1->(GetArea())
			aArea_SF2 := SF2->(GetArea())
			aArea_SD1 := SD1->(GetArea())
			aArea_SD2 := SD2->(GetArea())
			aArea_SC6 := SC6->(GetArea())
		
			aItens    := {}
			aItPed    := {}
			c_NumRes  := ""
			c_TipRes  := ""
		
			DbSelectArea("SC6")
			SC6->(DbSetOrder(1))
		
			DbSelectArea("SC0")
			SC0->(DbSetOrder(3))
		
			DbSelectArea("SD2")
			SD2->(DbSetOrder(3))
		
			DbSelectArea("SF2")
			SF2->(DbSetOrder(1))
			SF2->(DbSeek(c_FilOrig + SF2->F2_DOC + SF2->F2_SERIE + SF2->F2_DOC + SF2->F2_CLIENTE + c_LojaOrig ))
		
			DbSelectArea("SD1")
			SD1->(DbSetOrder(1))
			SD1->(DbSeek(xFilial("SD1")+SF1->(F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA) ))
		
			c_NumPV		:= SD1->D1_DOC+SD1->D1_SERIE
			c_NumNF		:= SD1->D1_DOC
		
			While SD1->(!EOF()) .and. SF1->(F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA) == SD1->(D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA)
				If SD2->(DbSeek(c_FilOrig + SD1->D1_DOC + SD1->D1_SERIE + SD1->D1_FORNECE + c_LojaOrig + SD1->D1_COD ))
					If SC6->(DbSeek(c_FilOrig + SD2->D2_PEDIDO + SD2->D2_ITEMPV + SD2->D2_COD ))
					
						If SC6->C6_XRETIDO == "1"
							c_TipRes := "04"
						
						ElseIf SC6->C6_XQUAREN == "1"
							c_TipRes := "03"
						Else
							c_TipRes := ""
						EndIf
					
					//  ***************** Exclui Reserva em Transito
						If SC0->(DbSeek( c_FilOrig + SD2->D2_DOC + SD2->D2_SERIE + SD2->D2_ITEM  ))
							RecLock("SC0", .F.)
							SC0->C0_QUANT := SD2->D2_QUANT
							SC0->(DbDelete())
							SC0->(MsUnLock())
						
							SB2->(DbSetOrder(1))
							If SB2->(DbSeek(c_FilOrig + SD2->D2_COD + SD2->D2_LOCAL ))
								RecLock("SB2",.F.)
								SB2->B2_RESERVA -= SD2->D2_QUANT
								MsUnLock()
							EndIf
						EndIf
				
						If !Empty(c_TipRes) .And. SF1->F1_FILIAL == "20"
						
						////////////////////////////////////////////////////				
						// Conforme solicitação do C.Q., busco por pallet //
						////////////////////////////////////////////////////
							DbSelectArea("ZBB")
							DbSetOrder(8) //ZBB_FILIAL, ZBB_PEDIDO, ZBB_PRODUT, R_E_C_N_O_, D_E_L_E_T_
							DbSeek(SC6->(C6_FILIAL+C6_NUM+C6_PRODUTO), .F.)
						
							While ( ZBB->(!Eof()) .And. ZBB->(ZBB_FILIAL+ZBB_PEDIDO+ZBB_PRODUT) == SC6->(C6_FILIAL+C6_NUM+C6_PRODUTO) )
					
								If ( ZBB->ZBB_NOTA == SD2->D2_DOC )
								
									DbSelectArea("ZAA")
									DbSetOrder(2)//ZAA_FILIAL, ZAA_NUMPAL, ZAA_LOTEIN, R_E_C_N_O_, D_E_L_E_T_
									If DbSeek(ZBB->(ZBB_FILIAL+ZBB_NUMPAL))
										If Empty(ZAA->ZAA_FABPI)
											d_Fabricado := ZAA->ZAA_DATAGE
										Else
											d_Fabricado := ZAA->ZAA_FABPI
										EndIf
									Else
										d_Fabricado := StoD("20491231")
									EndIf																	
							
									aAdd(aItPed, { SD1->D1_COD, SD1->D1_LOCAL, ZBB->ZBB_QTDPAL, SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_ITEM, c_TipRes, "", Ctod(""), ZBB->ZBB_NUMPAL, SC6->C6_XCODCQ, d_Fabricado, ZBB->ZBB_LOTE})
							
								Endif
							
								ZBB->(DbSkip())
							
							Enddo
						
						EndIf
					EndIf
				EndIf
			
				SD1->(dbSkip())
			End
		                                      
			cFilBKP := cFilAnt
			cFilAnt := c_FilOrig
		
		//  ***************** Cria nova Reserva do Produto Retido ou em Quarentena
			If Len(aItPed) > 0
				l_Ret1 := U_fReserPV( c_NumPV, aItPed, c_NumRes, "PD", "A" )
			
				If l_Ret1 == .F.
					Final("Não conseguiu reservar, Verifique")
				EndIf
			EndIf
		
			cFilAnt := cFilBKP
		
			RestArea(aArea_SC6)
			RestArea(aArea_SD2)
			RestArea(aArea_SD1)
			RestArea(aArea_SF2)
			RestArea(aArea_SF1)
		
		EndIf
	//*************  Cintia Araujo - 06/2015 - Fim - ***********************
	
		//Exclui a reserva em transito na transferencia de retorno para filial de origem (AVARIA, CQ, etc..)
		If SD1->D1_FORNECE == "999999"
		
			aArea_SD1 := SD1->(GetArea())
		
			DbSelectArea("SD1")
			SD1->(DbSetOrder(1))
			SD1->(DbSeek(xFilial("SD1")+SF1->(F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA) ))
			
			While SD1->(!EOF()) .and. SF1->(F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA) == SD1->(D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA)
		
				DbSelectArea("SC0")
				SC0->(DbSetOrder(3))
				If SC0->(DbSeek( SD1->D1_FILIAL + "TF" + SD1->(D1_DOC + D1_SERIE + D1_ITEM)))
					
					If SD1->D1_FILIAL == "05" .And. SD1->D1_LOJA == "20" //Filial 11
						c_FornLj := "F5" 
					ElseIf SD1->D1_FILIAL == "05" .And. SD1->D1_LOJA == "23" //Filial 20
						c_FornLj := "F6" 
					ElseIf SD1->D1_FILIAL == "20" .And. SD1->D1_LOJA == "20" //Filial 11
						c_FornLj := "F2"
					EndIf
				
					RecLock("SC0", .F.)
					SC0->C0_QUANT := SD1->D1_QUANT
					SC0->(DbDelete())
					SC0->(MsUnLock())
				
					SB2->(DbSetOrder(1))
					If SB2->(DbSeek(SD1->(D1_FILIAL + SD1->D1_COD) + c_FornLj ))
						RecLock("SB2",.F.)
						SB2->B2_RESERVA -= SD1->D1_QUANT
						MsUnLock()
					EndIf
				EndIf
				
				SD1->(DbSkip())
				
			EndDo	
			
			RestArea(aArea_SD1)
			
		EndIf						
	//***********************************************************************************************************************************
	//Chamado 61474 - Michael Castro (Tipos de Especie que podem enviar email de notificação caso o campo F1_CHVNFE estiver em branco)
	//Foi criado o PARAMETRO [MV_XESPNFE] para não precisar incluir novos tipos de especie que necessitem de validação
	//***********************************************************************************************************************************
		If (INCLUI .Or. l_EhClassif) .And. SF1->F1_FORMUL <> 'S' .And. SF1->F1_ESPECIE $ Alltrim(GetMv("MV_XESPNFE")) .And. AllTrim(Funname()) == "MATA103"
			If Empty(AllTrim(SF1->F1_CHVNFE))
				fSndNFSmChv()
			EndIf
		EndIf
	           
	//Encerra pedido em aberto ch. 37145 - Felipe A. Reis
	
		DbSelectArea("SD1")
		SD1->(DbSetOrder(1))
		SD1->(DbGoTop())
		SD1->(DbSeek(xFilial("SD1")+SF1->(F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA)))
	
	//Percorre os itens da NF           
		While SD1->(!Eof()) .And. SF1->(F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA) == SD1->(D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA)
		
			DbSelectArea("SF4")
			SF4->(DbSetOrder(1))
			SF4->(DbSeek(xFilial("SF4")+SD1->D1_TES))
		
		//Verifica se deve atualizar a quantidade atendida por item
			If SF4->F4_ESTOQUE == "S" .And. SF4->F4_QTDZERO == "1" .And. SD1->D1_QUANT == 0 .And. !Empty(SD1->D1_PEDIDO)
		
				DbSelectArea("SC7")
				SC7->(DbSetOrder(1))
				SC7->(DbSeek(xFilial("SC7")+SD1->(D1_PEDIDO+D1_ITEMPC)))
			
				aAdd(a_Pedido,{SD1->D1_PEDIDO,SD1->D1_ITEMPC})
			
				RecLock("SC7",.F.)
				SC7->C7_QUJE := SC7->C7_QUANT
				MsUnlock()
			
			EndIf
		
			SD1->(DbSkip())
		
		EndDo
	
	//Verifico se o pedido pode ser finalizado
		For i := 1 To Len(a_Pedido)
		
		//Verifica se todos os itens foram atendidos
			DbSelectArea("SC7")
			SC7->(DbSetOrder(1))
			SC7->(DbSeek(xFilial("SC7")+a_Pedido[i][1]))
		
			While SC7->(!Eof) .And. xFilial("SC7")+a_Pedido[i][1]+a_Pedido[i][2] == SC7->(C7_FILIAL+C7_NUM+C7_ITEM)
			
				If SC7->C7_QUJE == SC7->C7_QUANT
					RecLock("SC7",.F.)
					SC7->C7_ENCER := "E"
					MsUnlock()
				EndIf
			
				SC7->(DbSkip())
			EndDo
		
		Next i

	Endif

//Atualiza informacoes do WMS com o Status de Processado
	If cFilAnt == "11" .And. SF1->F1_FORNECE = "999999"	.And. l_EhClassif .And. !(l103Auto)
	
	//Posiciona no primeiro item da nota
		DbSelectArea("SD1")
		SD1->(DbSetOrder(1))//D1_FILIAL, D1_DOC, D1_SERIE, D1_FORNECE, D1_LOJA, D1_COD, D1_ITEM, R_E_C_N_O_, D_E_L_E_T_
		SD1->(DbGoTop())
		SD1->(DbSeek(SF1->(F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA)))
	
	//Somente Produtos que são controlados pelo WMS		
		While SD1->(!Eof()) .And. SF1->(F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA) == SD1->(D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA)
			If GetAdvFVal("SB1","B1_XWMS",xFilial("SB1")+SD1->D1_COD,1,"") == "1"
				Processa({|| u_fNFEWMS(2) },"Processando Informações no WMS... Por Favor Aguarde.") //Atualiza status WMS
				Exit
			EndIf
			SD1->(DbSkip())
		EndDo
		
	//Executa rotina de reservas
		u_GDC04WMS(.F.)
		
	EndIf

//Atualiza informacoes do WMS para voltar o status de nao processado
	If cFilAnt == "11" .And. SF1->F1_FORNECE = "999999"	.And. l_NaoEhClas .And. !(l103Auto) .And. AllTrim(FunName()) == "MATA140"
	
	//Posiciona no primeiro item da nota
		DbSelectArea("SD1")
		SD1->(DbSetOrder(1))//D1_FILIAL, D1_DOC, D1_SERIE, D1_FORNECE, D1_LOJA, D1_COD, D1_ITEM, R_E_C_N_O_, D_E_L_E_T_
		SD1->(DbGoTop())
		SD1->(DbSeek(SF1->(F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA)))
	
	//Somente Produtos que são controlados pelo WMS		
		While SD1->(!Eof()) .And. SF1->(F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA) == SD1->(D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA)
			If GetAdvFVal("SB1","B1_XWMS",xFilial("SB1")+SD1->D1_COD,1,"") == "1"
				Processa({|| u_fNFEWMS(3) },"Processando Informações no WMS... Por Favor Aguarde.") //Volta status do WMS
				Exit
			EndIf
			SD1->(DbSkip())
		EndDo
	
	//Executa rotina de reservas
		u_GDC04WMS(.F.)
		
	EndIf

/////////////////////////////////////////////////////////////////
//ENVIA E-MAIL QUANDO NOTAS DE ORIGENS ESTIVEREM DIFERENTES 08/04/16 (Chamado 59256)
	If (SF1->F1_FILIAL == "05" .Or. SF1->F1_FILIAL == "20") .And. (SF1->F1_FORNECE = "999999") .And. (SF1->F1_TIPO == "N") .And. (l_EhClassif) .And. !(l103Auto)
	//Pega a Filial origem a NF
		c_FilSF2 := ""
		dbSelectArea("SX5")
		dbSetOrder(1)
		dbSeek(xFilial("SX5")+"ZD",.F.)
		While SX5->(!Eof()) .And. SX5->(X5_FILIAL+X5_TABELA) == xFilial("SX5")+"ZD"
			If SubStr(SX5->X5_CHAVE,4,2) == SF1->F1_LOJA .And. Left(SX5->X5_CHAVE, 1) == "F"
				c_FilSF2 := AllTrim(SX5->X5_DESCRI)
				Exit
			EndIf
			SX5->(dbSkip())
		EndDo
	//Pega a Loja origem a NF
		c_LjClie := ""
		dbSelectArea("SX5")
		dbSetOrder(1)
		dbSeek(xFilial("SX5")+"ZD",.F.)
		While SX5->(!Eof()) .and. SX5->(X5_FILIAL+X5_TABELA) == xFilial("SX5")+"ZD"
			If AllTrim(SX5->X5_DESCRI) == SF1->F1_FILIAL .And. Left(SX5->X5_CHAVE, 1) == "C"
				c_LjClie := SUBSTRING(X5_CHAVE,4,2)
				Exit
			EndIf
			SX5->(dbSkip())
		EndDo
	//Posiciona no primeiro item da nota
		dbSelectArea("SD1")
		SD1->(dbSetOrder(1))//D1_FILIAL, D1_DOC, D1_SERIE, D1_FORNECE, D1_LOJA, D1_COD, D1_ITEM, R_E_C_N_O_, D_E_L_E_T_
		SD1->(dbSeek(SF1->(F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA)))
		While SD1->(!Eof()) .And. SF1->(F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA) == SD1->(D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA)
		
			dbSelectArea("SD2")
			SD2->(dbSetOrder(3))//D2_FILIAL, D2_DOC, D2_SERIE, D2_CLIENTE, D2_LOJA, D2_COD, D2_ITEM, R_E_C_N_O_, D_E_L_E_T_
			SD2->(dbSeek(c_FilSF2+SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+c_LjClie+SD1->D1_COD+SD1->D1_ITEM))
			While SD2->(!Eof()) .And. SD2->(D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA+D2_COD+PADR(D2_ITEM,TAMSX3("D1_ITEM")[1])) == c_FilSF2+SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+c_LjClie+SD1->D1_COD+SD1->D1_ITEM
		
				dbSelectArea("SF4")
				SF4->(dbSetOrder(1))//F4_FILIAL, F4_CODIGO, R_E_C_N_O_, D_E_L_E_T_
				SF4->(dbSeek(SD2->(D2_FILIAL+D2_TES)))
			
				If (SD2->D2_FILIAL == "11" .And. SD1->D1_FILIAL == "05") .Or. (SD2->D2_FILIAL == "11" .And. SD1->D1_FILIAL == "20") .Or. (SD2->D2_FILIAL == "20" .And. SD1->D1_FILIAL == "05")
					If !Empty(SD2->D2_NFORI) .And. !Empty(SD1->D1_NFORI)
						If AllTrim(SF4->F4_CF) == "5906"
							If !Empty(SD1->D1_NFORI)
								If (SD2->D2_NFORI # SD1->D1_NFORI)
									aAdd(a_Divergs,{SD2->D2_FILIAL, SD2->D2_DOC, SD2->D2_COD, SD2->D2_TES, SD2->D2_QUANT, SD2->D2_NFORI, SD2->D2_LOCAL, SD1->D1_FILIAL, SD1->D1_DOC, SD1->D1_COD, SD1->D1_TES, SD1->D1_QUANT, SD1->D1_NFORI, SD1->D1_LOCAL})
								EndIf
							EndIf
						EndIf
					EndIf
				EndIf
		
				SD2->(dbSkip())
				
			EndDo
		
			SD1->(dbSkip())
	
		EndDo
	
	EndIf

	If Len(a_Divergs) > 0
		fEnvMail2(a_Divergs)
	EndIf

	//Provisorio para nao aparecer a tela de CNPJ 2x - Ch.89041
	If Type("l_UNQNF") <> "U" 
		l_UNQNF := .F.
	EndIf

	//CH 74524 - LOG
	U_GrvLogFunc("MT103FIM", a_VarsLog)

	RestArea(a_AreaSM0)
	RestArea(a_AreaSD1)

Return(Nil)

/******************************************************************************/

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ fEnvMail ³ Autor ³Felipe Azevedo dos Reis³ Data ³ 02/10/12 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Envio de email com informacoes de Títulos em aberto que    ³±±
±±³          ³podem ser compensados                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nil => Nenhum                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nil => Nenhum                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Analista Resp.³  Data  ³ Manutencao Efetuada                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³              ³  /  /  ³                                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function fEnvMail()

	Local c_Query 	:= ""
	Local c_Eol 	:= Chr(13) + Chr(10)
	Local c_MailCorp:= ""
	Local c_Assunto := "Títulos para compensação de NF"


	If !(SF1->F1_TIPO $ "BD")
		c_Query := "SELECT E2_MSFIL, E2_TIPO, E2_PREFIXO, E2_NUM, E2_PARCELA, E2_EMISSAO, E2_VENCREA, E2_VALOR, E2_SALDO FROM "+RetSqlName("SE2")+ c_Eol
		c_Query += "WHERE E2_TIPO IN ('PA','NDF')" + c_Eol
		c_Query += "AND E2_FORNECE = '"+SF1->F1_FORNECE+"'" + c_Eol
		c_Query += "AND E2_LOJA = '"+SF1->F1_LOJA+"'" + c_Eol
		c_Query += "AND E2_SALDO > 0" + c_Eol
		c_Query += "AND D_E_L_E_T_ = ''" + c_Eol

		If Select("QRYSE2") > 0
			QRYSE2->(DbCloseArea())
		Endif
	
		TcQuery c_Query New Alias "QRYSE2"
	
		If QRYSE2->(!Eof())
	
			c_MailCorp += '<HTML><!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">'
			c_MailCorp += '		<html xmlns="http://www.w3.org/1999/xhtml">'
			c_MailCorp += '		<style type="text/css">'
			c_MailCorp += '			.tituloPag { FONT-SIZE: 20px; COLOR: #666699; FONT-FAMILY: Arial, Helvetica, sans-serif; TEXT-DECORATION: none; font-weight: bold; }'
			c_MailCorp += '			.formulario { FONT-SIZE: 10px; COLOR: #000000; FONT-FAMILY: Verdana, Arial, Helvetica, sans-serif; TEXT-DECORATION: none; font-weight: bold; }'
			c_MailCorp += '			.formulario2{ FONT-SIZE: 11px; COLOR: #333333; FONT-FAMILY: Verdana, Arial, Helvetica, sans-serif; TEXT-DECORATION: none; }'
			c_MailCorp += '			.formularioTit { FONT-SIZE: 13px; COLOR: #000000; FONT-FAMILY: Verdana, Arial, Helvetica, sans-serif; TEXT-DECORATION: none; font-weight: bold; }'
			c_MailCorp += '		</style>'
			c_MailCorp += '	<head>'
			c_MailCorp += '		<title>GDC Alimentos - Informações Comerciais</title>'
			c_MailCorp += '	</head>'
		
			c_MailCorp += '	<body>'
		
			c_MailCorp += '	<table width="95%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#cccccc" class="formulario2"'
		
			c_MailCorp += '	<tr>'
			c_MailCorp += '		<td colspan="9" bgcolor="#C5D1CB">'
			c_MailCorp += '		<div align="center"><span class="formularioTit">Dados da Nota Fiscal</span></div>'
			c_MailCorp += '		</td>'
			c_MailCorp += '	</tr>'
		
			c_MailCorp += '	<tr>'
			c_MailCorp += '		<td colspan="9">&nbsp;</td>'
			c_MailCorp += '	</tr>'
		
			c_MailCorp += '	<tr>'
			c_MailCorp += '		<td colspan="2" bgcolor="#C5D1CB" class="formulario">Filial</td>'
			c_MailCorp += '		<td colspan="7" class="formulario">'+SF1->F1_FILIAL+'</td>'
			c_MailCorp += '	</tr>'
		
			c_MailCorp += '	<tr>'
			c_MailCorp += '		<td colspan="2" bgcolor="#C5D1CB" class="formulario">Nota Fiscal</td>'
			c_MailCorp += '		<td colspan="7" class="formulario">'+SF1->F1_DOC+'/'+SF1->F1_SERIE+'</td>'
			c_MailCorp += '	</tr>'
		
			c_MailCorp += '	<tr>'
			c_MailCorp += '		<td colspan="2" bgcolor="#C5D1CB" class="formulario">Fornecedor</td>'
			c_MailCorp += '		<td colspan="7" class="formulario">'+SF1->F1_FORNECE+'/'+SF1->F1_LOJA+' - '+GetAdvfVal("SA2","A2_NOME",xFilial("SA2")+SF1->(F1_FORNECE+F1_LOJA),1,"")+'</td>'
			c_MailCorp += '	</tr>'
		
			c_MailCorp += '	<tr>'
			c_MailCorp += '		<td colspan="9">&nbsp;</td>'
			c_MailCorp += '	</tr>'
		
			c_MailCorp += '	<tr>'
			c_MailCorp += '		<td colspan="9" bgcolor="#C5D1CB">'
			c_MailCorp += '		<div align="center"><span class="formularioTit">Títulos em aberto que podem ser compensados</span></div>'
			c_MailCorp += '		</td>'
			c_MailCorp += '	</tr>'
			
			c_MailCorp += '	<tr>'
			c_MailCorp += '		<td colspan="9">&nbsp;</td>'
			c_MailCorp += '	</tr>'
		
			c_MailCorp += '	<tbody>'
		
			c_MailCorp += '		<tr bgcolor="#336699">'
			c_MailCorp += '			<td width="05%" align="Center" bgcolor="#C5D1CB" class="formulario">Filial</td>'
			c_MailCorp += '			<td width="05%" align="Center" bgcolor="#C5D1CB" class="formulario">Tipo</td>'
			c_MailCorp += '			<td width="05%" align="Center" bgcolor="#C5D1CB" class="formulario">Prefixo</td>'
			c_MailCorp += '			<td width="20%" align="Center" bgcolor="#C5D1CB" class="formulario">Título</td>'
			c_MailCorp += '			<td width="05%" align="Center" bgcolor="#C5D1CB" class="formulario">Parcela</td>'
			c_MailCorp += '			<td width="15%" align="Center" bgcolor="#C5D1CB" class="formulario">Data Emissao</td>'
			c_MailCorp += '			<td width="15%" align="Center" bgcolor="#C5D1CB" class="formulario">Vencimento</td>'
			c_MailCorp += '			<td width="15%" align="Center" bgcolor="#C5D1CB" class="formulario">Valor</td>'
			c_MailCorp += '			<td width="15%" align="Center" bgcolor="#C5D1CB" class="formulario">Saldo</td>'
			c_MailCorp += '		</tr>'
		
			While QRYSE2->(!Eof())
							
				c_MailCorp += '		<tr>'
				c_MailCorp += '		     <td align="Center">'+QRYSE2->E2_MSFIL+'</td>'
				c_MailCorp += '		     <td align="Center">'+QRYSE2->E2_TIPO+'</td>'
				c_MailCorp += '		     <td align="Center">'+QRYSE2->E2_PREFIXO+'</td>'
				c_MailCorp += '		     <td align="Center">'+QRYSE2->E2_NUM+'</td>'
				c_MailCorp += '		     <td align="Center">'+QRYSE2->E2_PARCELA+'</td>'
				c_MailCorp += '		     <td align="Center">'+DtoC(StoD(QRYSE2->E2_EMISSAO))+'</td>'
				c_MailCorp += '		     <td align="Center">'+DtoC(StoD(QRYSE2->E2_VENCREA))+'</td>'
				c_MailCorp += '		     <td align="Center">'+Transform(QRYSE2->E2_VALOR,"@E 999,999,999.99")+'</td>'
				c_MailCorp += '		     <td align="Center">'+Transform(QRYSE2->E2_SALDO,"@E 999,999,999.99")+'</td>'
				c_MailCorp += '		</tr>'
			
				QRYSE2->(DbSkip())
		
			EndDo
		
			c_MailCorp += '	</tbody>'
		
			c_MailCorp += '	<tr>'
			c_MailCorp += '		<td colspan="9" class="formulario"><p>&nbsp;</p></td>'
			c_MailCorp += '	</tr>'
		
			c_MailCorp += '	<tr>'
			c_MailCorp += '		<td colspan="9" bgcolor="#C5D1CB"><div align="center"><span class="formulario">Informática Gomes da Costa</span></div></td>'
			c_MailCorp += '	</tr>'
		
			c_MailCorp += '	<tr>'
			c_MailCorp += '		<td colspan="9" bgcolor="#C5D1CB"><div align="center"><span class="formulario">Ajudando você no seu dia-a-dia!</span></div></td>'
			c_MailCorp += '	</tr>'
		
			c_MailCorp += '	</table>'
			c_MailCorp += '	</body>'
			c_MailCorp += '	</html>'
		
			U_GDCSendMail("","",GetMV("MV_RELSERV"),"0076",c_Assunto,c_MailCorp,"","","")
				
		EndIf
	
		If Select("QRYSE2") > 0
			QRYSE2->(DbCloseArea())
		Endif
                                            
	EndIf

Return(Nil)

//*************************************************************************************************************

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    | fSndNFSmChv ³ Autor ³Ewerton H. Cozaciuc  ³ Data ³ 22/03/16 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Envia email com NF que foi classificada sem Chv NFE         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nenhum.                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nil.                                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Analista Resp.³  Data  ³ Manutencao Efetuada                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function fSndNFSmChv()

	Local c_Assunto		:= "Mensageiro Protheus - Chave NFE com Divergência!"
	Local n_Item 		:= 0
	Local c_ComCopia	:= ""
	Local c_MailCorp	:= ""
	Local c_Filial  	:= SF1->F1_FILIAL

	c_Assunto += ' - FILIAL '+SF1->F1_FILIAL+' / NF - '+SF1->F1_DOC+'/'+SF1->F1_SERIE+' '

	c_MailCorp += '<HTML><!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">'
	c_MailCorp += '	<html xmlns="http://www.w3.org/1999/xhtml">'
	c_MailCorp += '	<style type="text/css">'
	c_MailCorp += '		.tituloPag { FONT-SIZE: 20px; COLOR: #666699; FONT-FAMILY: Arial, Helvetica, sans-serif; TEXT-DECORATION: none; font-weight: bold; }'
	c_MailCorp += '		.formulario { FONT-SIZE: 10px; COLOR: #000000; FONT-FAMILY: Verdana, Arial, Helvetica, sans-serif; TEXT-DECORATION: none; font-weight: bold; }'
	c_MailCorp += '		.formulario2{ FONT-SIZE: 11px; COLOR: #333333; FONT-FAMILY: Verdana, Arial, Helvetica, sans-serif; TEXT-DECORATION: none; }'
	c_MailCorp += '		.formularioTit { FONT-SIZE: 13px; COLOR: #000000; FONT-FAMILY: Verdana, Arial, Helvetica, sans-serif; TEXT-DECORATION: none;  }'
	c_MailCorp += '		.formularioTit2 { FONT-SIZE: 15px; COLOR: #FFFFFF; FONT-FAMILY: Verdana, Arial, Helvetica, sans-serif; TEXT-DECORATION: none; font-weight: bold; }'
	c_MailCorp += '	</style>'
	c_MailCorp += '<head>'
	c_MailCorp += '	<title>GDC Alimentos - Nota com Chave NFE inválida</title>'
	c_MailCorp += '</head>'
	
	c_MailCorp += '<table width="95%" border="0" align="center">'
	c_MailCorp += '<tr>'
	c_MailCorp += '	<td colspan="7" >'
	c_MailCorp += '		<img src="'+GetMV("MV_XLOGO")+'" border="0">'
	c_MailCorp += '	</td>'
	c_MailCorp += '<tr>'
	
	c_MailCorp += '<tr>'
	c_MailCorp += '	<td colspan="8" bgcolor="#C5D1CB">'
	c_MailCorp += '		<div align="center"><span class="formularioTit2"><H2>Aviso Eletrônico</H2></span></div>'
	c_MailCorp += '	</td>'
	c_MailCorp += '</tr>'
	c_MailCorp += '<tr>'
	c_MailCorp += '	<td colspan="10">&nbsp;</td>'
	c_MailCorp += '</tr>'
	
	c_MailCorp += '<tr>'
	c_MailCorp += '	<td colspan="10"><span class="formularioTit1">Olá,</span></td>'
	c_MailCorp += '</tr>'
		
	c_MailCorp += '<tr>'
	c_MailCorp += '	<td colspan="8"><span class="formularioTit1"> Abaixo seguem algumas informações da Nota Fiscal que será necessário verificar a Chave NFE:</span></td>'
	c_MailCorp += '</tr>'
	c_MailCorp += '<tr>'
	c_MailCorp += '	<td colspan="10">&nbsp;</td>'
	c_MailCorp += '</tr>'

	c_MailCorp += "<body>"

	c_MailCorp += '<table width="95%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#cccccc" class="formulario2">'

	c_MailCorp += '<tr>'
	c_MailCorp += '	<td colspan="7" bgcolor="#C5D1CB">'
	c_MailCorp += '		<div align="center"><span class="formularioTit">FAVOR VERIFICAR A CHAVE NFE DA NOTA: '+SF1->F1_DOC+'/'+SF1->F1_SERIE+' </span></div>'
	c_MailCorp += '	</td>'
	c_MailCorp += '</tr>'
	c_MailCorp += '<tr>'
	c_MailCorp += '	<td colspan="7">&nbsp;</td>'
	c_MailCorp += '</tr>'

	c_MailCorp += '<tr>'
	c_MailCorp += '	<td colspan="7" bgcolor="#C5D1CB"><div align="center"><span class="formulario">INFORMAÇÃO DA NOTA</span></div></td>'
	c_MailCorp += '</tr>'

	c_MailCorp += '	<tbody>'

	c_MailCorp += '	<tr bgcolor="#336699">'
	c_MailCorp += '		<td width="5%"  align="Center" bgcolor="#C5D1CB" class="formulario">FILIAL</td>' //F2_FILIAL
	c_MailCorp += '		<td width="10%" align="Center" bgcolor="#C5D1CB" class="formulario">NOTA</td>' //F2_DOC
	c_MailCorp += '		<td width="10%" align="Center" bgcolor="#C5D1CB" class="formulario">SERIE</td>' //F2_SERIE
	c_MailCorp += '		<td width="10%" align="Center" bgcolor="#C5D1CB" class="formulario">FORNECEDOR</td>' //F2_CLIENTE
	c_MailCorp += '		<td width="10%" align="Center" bgcolor="#C5D1CB" class="formulario">LOJA</td>' //F2_LOJA
	c_MailCorp += '		<td width="10%" align="Center" bgcolor="#C5D1CB" class="formulario">ESTADO</td>' //F2_EST
	c_MailCorp += '		<td width="10%" align="Center" bgcolor="#C5D1CB" class="formulario">ESPECIE</td>' //F2_EST
	c_MailCorp += '	</tr>'

	c_MailCorp += '     <td align="Center">'+SF1->F1_FILIAL+'</td>'
	c_MailCorp += '     <td align="Center">'+SF1->F1_DOC+'</td>'
	c_MailCorp += '     <td align="Center">'+SF1->F1_SERIE+'</td>'
	c_MailCorp += '     <td align="Center">'+SF1->F1_FORNECE+'</td>'
	c_MailCorp += '     <td align="Center">'+SF1->F1_LOJA+'</td>'
	c_MailCorp += '     <td align="Center">'+SF1->F1_EST+'</td>'
	c_MailCorp += '     <td align="Center">'+SF1->F1_ESPECIE+'</td>'
	c_MailCorp += ' </tr>'
	
	c_MailCorp += '	</tbody>'

	c_MailCorp += '<tr>'
	c_MailCorp += '	<td colspan="7" class="formulario"><p>&nbsp;</p></td>'
	c_MailCorp += '</tr>'

	c_MailCorp += '<tr>'
	c_MailCorp += '	<td colspan="7" bgcolor="#C5D1CB"><div align="center"><span class="formulario">Informática Gomes da Costa</span></div></td>'
	c_MailCorp += '</tr>'

	c_MailCorp += '<tr>'
	c_MailCorp += '	<td colspan="7" bgcolor="#C5D1CB"><div align="center"><span class="formulario">Ajudando você no seu dia-a-dia!</span></div></td>'
	c_MailCorp += '</tr>'

	c_MailCorp += '</table>'
	c_MailCorp += '</body>'
	c_MailCorp += '</html>'

	If c_Filial == '02'

	//Envia o E-mail
		U_GDCSendMail("","",GetMV("MV_RELSERV"),"0120",c_Assunto,c_MailCorp,"","","")// Marcio de Freitas Oliveira/Risia Andrade dos Santos/ Wanderson Rodrigues Vieira e Simone Frigo Orsi

	ElseIf c_Filial == '05'

	//Envia o E-mail
		U_GDCSendMail("","",GetMV("MV_RELSERV"),"0121",c_Assunto,c_MailCorp,"","","")// fiscal@gomesdacosta.com.br/Risia Andrade dos Santos/ Wanderson Rodrigues Vieira e Simone Frigo Orsi

	ElseIf c_Filial == '07'

	//Envia o E-mail
		U_GDCSendMail("","",GetMV("MV_RELSERV"),"0122",c_Assunto,c_MailCorp,"","","")// cdpe@gomesdacosta.com.br/Risia Andrade dos Santos/ Wanderson Rodrigues Vieira e Simone Frigo Orsi

	ElseIf c_Filial == '11'

	//Envia o E-mail
		U_GDCSendMail("","",GetMV("MV_RELSERV"),"0123",c_Assunto,c_MailCorp,"","","")//Risia Andrade dos Santos/ Wanderson Rodrigues Vieira e Simone Frigo Orsi

	ElseIf c_Filial == '20'

	//Envia o E-mail
		U_GDCSendMail("","",GetMV("MV_RELSERV"),"0124",c_Assunto,c_MailCorp,"","","")//fiscalgdce@gomesdacosta.com.br/Risia Andrade dos Santos/ Wanderson Rodrigues Vieira e Simone Frigo Orsi
	
	EndIF

Return Nil

/**********************************************************************************************/


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    | fEnvMail2   ³ Autor ³ Flavio Valentin     ³ Data ³ 12/04/16 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Funcao que envia e-mail quando existe divergencia de NF Orig³±±
±±³          ³ na Nota de Entrada em relacao a NF de Saida.                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ a_InfMail, parametros abaixo:                               ³±±
±±³          ³ Posicao 01 => Filial Nota de Saida.                         ³±±
±±³          ³ Posicao 02 => Nota Fiscal de Saida.                         ³±±
±±³          ³ Posicao 03 => Codigo do Produto.                            ³±±
±±³          ³ Posicao 04 => TES de Saida.                                 ³±±
±±³          ³ Posicao 05 => Quantidade.                                   ³±±
±±³          ³ Posicao 06 => Nota Fiscal de Origem (Nota de Saida).        ³±±
±±³          ³ Posicao 07 => Almoxarifado da Nota Fiscal de Saida.         ³±±
±±³          ³ Posicao 08 => Filial Nota de Entrada.                       ³±±
±±³          ³ Posicao 09 => Nota Fiscal de Entrada.                       ³±±
±±³          ³ Posicao 10 => Codigo do Produto.                            ³±±
±±³          ³ Posicao 11 => TES de Entrada.                               ³±±
±±³          ³ Posicao 12 => Quantidade.                                   ³±±
±±³          ³ Posicao 13 => Nota Fiscal de Origem (Nota de Entrada).      ³±±
±±³          ³ Posicao 14 => Almoxarifado da Nota Fiscal de Entrada.       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nil.                                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Analista Resp.³  Data  ³ Manutencao Efetuada                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³              |        ³                                                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function fEnvMail2(a_InfMail)

	Local c_Eol 	   := Chr(13) + Chr(10)
	Local c_Assunto  := "Divergência na Nota Fiscal de Origem"
	Local c_HTMLMail := ""
	Local n_Ini      := 0
	Local c_GrpMail  := "0044"

	If Len(a_InfMail)==0
		Return(Nil)
	EndIf

	c_HTMLMail := ""
	c_HTMLMail += '<font face="Arial" color="Black" size="4"><b>A Nota Fiscal de Origem informada no Documento de Entrada está diferente da informada no Documento de Saída. </b></font></p><br>'
	c_HTMLMail += '<font face="Arial" color="Black" size="4"><b>Abaixo os detalhes:. </b></font></p><br>'
	c_HTMLMail += '<Table border = "1" align=center Width="100%" height="10%">'

	c_HTMLMail += '<tr>'
	c_HTMLMail += '<td align=center width="20%" bgcolor="#000000"><p style="margin-top: 0; margin-bottom: 0"><b><font face="Arial" color="#FFFFFF"> Filial Orig. </font></b></td>'
	c_HTMLMail += '<td align=center width="20%" bgcolor="#000000"><p style="margin-top: 0; margin-bottom: 0"><b><font face="Arial" color="#FFFFFF"> NF de Saída </font></b></td>'
	c_HTMLMail += '<td align=center width="20%" bgcolor="#000000"><p style="margin-top: 0; margin-bottom: 0"><b><font face="Arial" color="#FFFFFF"> SKU</font></b></td>'
	c_HTMLMail += '<td align=center width="20%" bgcolor="#000000"><p style="margin-top: 0; margin-bottom: 0"><b><font face="Arial" color="#FFFFFF"> TES</font></b></td>'
	c_HTMLMail += '<td align=center width="20%" bgcolor="#000000"><p style="margin-top: 0; margin-bottom: 0"><b><font face="Arial" color="#FFFFFF"> Quantidade</font></b></td>'
	c_HTMLMail += '<td align=center width="20%" bgcolor="#000000"><p style="margin-top: 0; margin-bottom: 0"><b><font face="Arial" color="#FFFFFF"> NF Origem</font></b></td>'
	c_HTMLMail += '<td align=center width="20%" bgcolor="#000000"><p style="margin-top: 0; margin-bottom: 0"><b><font face="Arial" color="#FFFFFF"> Almox.</font></b></td>'
	c_HTMLMail += '<td align=center width="20%" bgcolor="#000000"><p style="margin-top: 0; margin-bottom: 0"><b><font face="Arial" color="#FFFFFF"> Filial Entrada. </font></b></td>'
	c_HTMLMail += '<td align=center width="20%" bgcolor="#000000"><p style="margin-top: 0; margin-bottom: 0"><b><font face="Arial" color="#FFFFFF"> NF de Entrada </font></b></td>'
	c_HTMLMail += '<td align=center width="20%" bgcolor="#000000"><p style="margin-top: 0; margin-bottom: 0"><b><font face="Arial" color="#FFFFFF"> SKU</font></b></td>'
	c_HTMLMail += '<td align=center width="20%" bgcolor="#000000"><p style="margin-top: 0; margin-bottom: 0"><b><font face="Arial" color="#FFFFFF"> TES</font></b></td>'
	c_HTMLMail += '<td align=center width="20%" bgcolor="#000000"><p style="margin-top: 0; margin-bottom: 0"><b><font face="Arial" color="#FFFFFF"> Quantidade</font></b></td>'
	c_HTMLMail += '<td align=center width="20%" bgcolor="#000000"><p style="margin-top: 0; margin-bottom: 0"><b><font face="Arial" color="#FFFFFF"> NF Origem</font></b></td>'
	c_HTMLMail += '<td align=center width="20%" bgcolor="#000000"><p style="margin-top: 0; margin-bottom: 0"><b><font face="Arial" color="#FFFFFF"> Almox.</font></b></td>'
	c_HTMLMail += '</tr>'
	n_Ini := 0
	For n_Ini := 1 To Len(a_InfMail)
		c_HTMLMail += '<tr>'
		c_HTMLMail += '<td align=left width="20%" bgcolor="#C0C0C0"><p style="margin-top: 0; margin-bottom: 0"><b><font face="Arial" color="#000000"> ' + a_InfMail[n_Ini][01] + '</font></b></td>'
		c_HTMLMail += '<td align=left width="20%" bgcolor="#C0C0C0"><p style="margin-top: 0; margin-bottom: 0"><b><font face="Arial" color="#000000"> ' + a_InfMail[n_Ini][02] + '</font></b></td>'
		c_HTMLMail += '<td align=left width="20%" bgcolor="#C0C0C0"><p style="margin-top: 0; margin-bottom: 0"><b><font face="Arial" color="#000000"> ' + a_InfMail[n_Ini][03] + '</font></b></td>'
		c_HTMLMail += '<td align=left width="20%" bgcolor="#C0C0C0"><p style="margin-top: 0; margin-bottom: 0"><b><font face="Arial" color="#000000"> ' + a_InfMail[n_Ini][04] + '</font></b></td>'
		c_HTMLMail += '<td align=right width="20%" bgcolor="#C0C0C0"><p style="margin-top: 0; margin-bottom: 0"><b><font face="Arial" color="#000000"> ' + Transform(a_InfMail[n_Ini][05],PesqPict("SD2","D2_QUANT",18)) + '</font></b></td>'
		c_HTMLMail += '<td align=left width="20%" bgcolor="#C0C0C0"><p style="margin-top: 0; margin-bottom: 0"><b><font face="Arial" color="#000000"> ' + a_InfMail[n_Ini][06] + '</font></b></td>'
		c_HTMLMail += '<td align=left width="20%" bgcolor="#C0C0C0"><p style="margin-top: 0; margin-bottom: 0"><b><font face="Arial" color="#FF0000"> ' + a_InfMail[n_Ini][07] + '</font></b></td>'
		c_HTMLMail += '<td align=left width="20%" bgcolor="#C0C0C0"><p style="margin-top: 0; margin-bottom: 0"><b><font face="Arial" color="#000000"> ' + a_InfMail[n_Ini][08] + '</font></b></td>'
		c_HTMLMail += '<td align=left width="20%" bgcolor="#C0C0C0"><p style="margin-top: 0; margin-bottom: 0"><b><font face="Arial" color="#000000"> ' + a_InfMail[n_Ini][09] + '</font></b></td>'
		c_HTMLMail += '<td align=left width="20%" bgcolor="#C0C0C0"><p style="margin-top: 0; margin-bottom: 0"><b><font face="Arial" color="#000000"> ' + a_InfMail[n_Ini][10] + '</font></b></td>'
		c_HTMLMail += '<td align=left width="20%" bgcolor="#C0C0C0"><p style="margin-top: 0; margin-bottom: 0"><b><font face="Arial" color="#000000"> ' + a_InfMail[n_Ini][11] + '</font></b></td>'
		c_HTMLMail += '<td align=right width="20%" bgcolor="#C0C0C0"><p style="margin-top: 0; margin-bottom: 0"><b><font face="Arial" color="#000000"> ' + Transform(a_InfMail[n_Ini][12],PesqPict("SD1","D1_QUANT",18)) + '</font></b></td>'
		c_HTMLMail += '<td align=left width="20%" bgcolor="#C0C0C0"><p style="margin-top: 0; margin-bottom: 0"><b><font face="Arial" color="#000000"> ' + a_InfMail[n_Ini][13] + '</font></b></td>'
		c_HTMLMail += '<td align=left width="20%" bgcolor="#C0C0C0"><p style="margin-top: 0; margin-bottom: 0"><b><font face="Arial" color="#FF0000"> ' + a_InfMail[n_Ini][14] + '</font></b></td>'
		c_HTMLMail += '</tr>'
	Next n_Ini
	c_HTMLMail += '</Table><br><br>'
	c_HTMLMail += '<tr>'
	c_HTMLMail += '<td colspan="7" class="formulario"><p>&nbsp;</p></td>'
	c_HTMLMail += '</tr>'
	c_HTMLMail += '<tr>'
	c_HTMLMail += '<td colspan="7" bgcolor="#C5D1CB"><div align="center"><span class="formulario">Informática Gomes da Costa</span></div></td>'
	c_HTMLMail += '</tr>'
	c_HTMLMail += '<tr>'
	c_HTMLMail += '<td colspan="7" bgcolor="#C5D1CB"><div align="center"><span class="formulario">Ajudando você no seu dia-a-dia!</span></div></td>'
	c_HTMLMail += '</tr>'
	c_HTMLMail += '</table>'
	c_HTMLMail += '</body>'
	c_HTMLMail += '</html>'

	MemoWrite("fEnvMail2.html",c_HTMLMail)

	U_GDCSendMail("","",GetMV("MV_RELSERV"),c_GrpMail,c_Assunto,c_HTMLMail,"","","")

Return(Nil)
//******************************************************************************************************************************************************************************//

Static Function fManutCF()

	Local c_ChvSD1	:= SF1->(F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA)
	Local a_AreaSD1 := SD1->(GetArea())
//	Local c_QryUpd	:= ""
//	Local a_MntEmp4	:= {}
	
	DbSelectArea("SD1")
	DbSetorder(1) //D1_FILIAL, D1_DOC, D1_SERIE, D1_FORNECE, D1_LOJA, D1_COD, D1_ITEM, R_E_C_N_O_, D_E_L_E_T_
	DbSeek(c_ChvSD1, .F.)
	
	While SD1->(!Eof()) .And. c_ChvSD1 == SD1->(D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA)
		
		If  !Empty(SD1->D1_XORIXML)

			DbSelectArea("SFT")
			DbSetOrder(1) // FT_FILIAL, FT_TIPOMOV, FT_SERIE, FT_NFISCAL, FT_CLIEFOR, FT_LOJA, FT_ITEM, FT_PRODUTO, R_E_C_N_O_, D_E_L_E_T_
			DbGoTop()
			If DbSeek( xFilial("SFT") + "E" + SD1->(D1_SERIE+D1_DOC+D1_FORNECE+D1_LOJA+D1_ITEM+D1_COD))
				SFT->(RecLock("SFT", .F.))
				SFT->FT_CLASFIS := SD1->D1_CLASFIS
				SFT->(MsUnLock())
			Endif
			
		Endif
		
		SD1->(Dbskip())
		
	Enddo
	
	RestArea(a_AreaSD1)

Return Nil

//***************************************************************************************************/
