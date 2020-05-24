#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TBICONN.CH"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ MA410DEL ³ Autor ³ Douglas Viegas Franca ³ Data ³ 05/03/04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Ponto de Entrada acionado antes da exclusao do pedido de   ³±±
±±³          ³venda. Este P.E. inicialmente foi utilizado para gerar e en-³±±
±±³          ³viar um arquivo txt para o site B2B.                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nil => Nenhum                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nil => Nenhum                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Analista Resp.³  Data  ³ Manutencao Efetuada                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Felipe A. Reis³17/06/11³Envio de e-mail com informacoes do PV cancelado³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function MA410DEL()

	
	Local lRet := .T.
		
	Local a_AreaATU 	:= GetArea()
	Local a_AreaSC6 	:= SC6->(GetArea())
	Local a_AreaSC5 	:= SC5->(GetArea())
	Local a_AreaSA3 	:= SA3->(GetArea())
	Local a_AreaSA1 	:= SA1->(GetArea())
	Local a_AreaZZN 	:= ZZN->(GetArea())
	Local c_Rotina 		:= FunName()
	Local c_Usuario		:= cUserName
	Local c_ComCopia	:= ""
	Local c_Assunto		:= ""
	
	Local a_InfLOG	:= {{SC5->C5_NUM, "", "1", "5", "", "", "", SC5->C5_CLIENTE, SC5->C5_LOJACLI, SC5->(C5_MSIDENT)}}
	
	//Exclui a SAP
	/* retirado devido projeto da SAP por CONTIGENCIA
	If SC5->C5_XSAP == "1"
		fExcSAP()
	Endif
	*/
	
	//Gravacao do LOG de exclusao do PV
	U_GDCGrLgPV(a_InfLOG, c_MotExcPV, c_ObsExcPV)
	
	// customização importador xml compila
	IF !EMPTY(SC5->C5_XCHVNFE)
		aAreaZ10	:= Z10->(GetArea())
						
		DBSELECTAREA("Z10")
		Z10->(DBSETORDER(1))	//| Z10_FILIAL, Z10_CHVNFE
		IF Z10->(DBSEEK(XFILIAL("Z10")+SC5->C5_XCHVNFE,.F.))
			
			RECLOCK("Z10",.F.)
				Z10->Z10_STATUS	:= "1"
				Z10->Z10_NUMPV	:= ""
			MSUNLOCK()
		ENDIF
		RestArea(aAreaZ10)	
	ENDIF
	
	//Envia e-mail com as informacoes do pedido cancelado
	If !Empty(c_PubMail)
		
		//Posiciono no cadastro do Cliente
		DbSelectArea("SA1")
		DbSetOrder(1)
		DbSeek(xFilial("SA1")+SC5->(C5_CLIENTE+C5_LOJACLI), .F.)
		
		//Posiciono no cadastro do Vendedor
		DbSelectArea("SA3")
		DbSetOrder(1)
		If DbSeek(xFilial("SA3")+SC5->C5_VEND1, .F.)
			c_ComCopia += IIF(!Empty(c_ComCopia),";","")+AllTrim(SA3->A3_EMAIL)
		EndIf
		
		//Posiciono no cadastro da Regional
		DbSelectArea("ZZN")
		DbSetOrder(1)
		If DbSeek(xFilial("ZZN")+Left(SA3->A3_REGIAO, 2), .F.)
			c_ComCopia += IIF(!Empty(c_ComCopia),";","")+AllTrim(ZZN->ZZN_EMAIL)
		EndIf
		
		c_Assunto := "INFORME - Cancelamento Pedido de Venda - Pedido cliente: "+AllTrim(SC5->C5_PEDCLI)+" - Nome: "+AllTrim(SA1->A1_NOME)+" - Vendedor: "+AllTrim(SC5->C5_VEND1)+" - Pedido ERP " + SC5->C5_NUM
		
		//Envia o E-mail
		U_GDCSendMail("","",GetMV("MV_RELSERV"),"0042",c_Assunto,c_PubMail,"","",c_ComCopia)
		
	EndIf
	
	RestArea(a_AreaSC6)
	RestArea(a_AreaSA1)
	RestArea(a_AreaSC5)
	RestArea(a_AreaSA3)
	RestArea(a_AreaZZN)
	RestArea(a_AreaATU)
	
	
Return (lRet)

/**********************************************************************************/

Static Function fExcSAP()
	
	Local a_AreaATU := GetArea()
	/*
	DbSelectArea("XE3")
	DbSetOrder(1) //XE3_FILIAL, XE3_NUMSAP, R_E_C_N_O_, D_E_L_E_T_
	If DbSeek(xFilial("XE3")+SC5->C5_XNUMSAP, .F.)
		
		DbSelectArea("XE4")
		DbSetOrder(1) //XE4_FILIAL, XE4_NUMSAP, XE4_ITEM, R_E_C_N_O_, D_E_L_E_T_
		DbSeek(XE3->(XE3_FILIAL+XE3_NUMSAP), .F.)
		
		While XE4->(!Eof()) .And. XE4->(XE4_FILIAL+XE4_NUMSAP) == XE3->(XE3_FILIAL+XE3_NUMSAP)
			RecLock("XE4", .F.)
			DbDelete()
			MsUnLock()
			XE4->(DbSkip())
		Enddo
		
		DbSelectArea("XE3")
		
		RecLock("XE3", .F.)
		Replace XE3_DTEXPL With CtoD("//")
		MsUnlock()
		
		RecLock("XE3", .F.)
		DbDelete()
		MsUnLock()
		
	Endif
	*/
	RestArea(a_AreaATU)
	
Return Nil

/**********************************************************************************/
