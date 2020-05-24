#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ A140EXC    ³ Autor ³ Douglas Viegas Franca     ³ Data ³ 16/05/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Permitir/Negar a exclusao da Pre-Nota.                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nil => Nenhum                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nil => Nenhum                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Analista Resp.³  Data  ³ Manutencao Efetuada                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Douglas Franca³28/09/10³[ID 9508] Controle das Comissoes                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Felipe Reis   ³12/01/16³ 3a Fase do projeto de Rastreabilidade.    	        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Felipe Aguiar ³12/01/18³ ID 73248: Bloquear exclusao caso tenha sido feita   ³±±
±±³              ³        ³ liberacacao para pagamento.                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³E. H. Cozaciuc³06/06/18³ ID 77368: Permitir a exclusao de prenota, sem veri- ³±±
±±³              ³        ³ ficar a liberacacao de pagamento.                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Mudança 1
Mudança 2
Mudanca 3
Mudanca 4
Na implanta nao esta assim, essa branch esta desatualizada

User Function A140EXC()

Local a_AreaATU	:= GetArea()
Local cCrLf 	:= Chr(13) + Chr(10)

//CH 74524 - LOG
Local a_VarsLog	:= {MsDate(), Time(), ""} //[1]-Data; [2]-Hora; [3]-Observacao

Local lImpNFE := GetMv("MV_XMLIMP",.F.,.F.) // Parametro integrador xml.

Local l_Ret := .T.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Utiliza sistema de importacao de XML ? ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
IF  lImpNFE .AND. l_Ret
	fRetStXML()				
ENDIF

//Tratamento para nao permitir excluir pre notas integradas com o PC-Factory
If !Empty(SF1->F1_XEXPPCF) .And. !IsInCallStack("A140ESTCLA")
	l_Ret := u_fPCFExclui()
EndIf

If l_Ret
	If SF1->F1_XNFTRAN == "S"
		l_Ret := .F.
		MsgStop("Não é possível excluir uma Pré-Nota gerada automaticamente pelo sistema."+CHR(13)+;
				"Para excluir essa Pré-Nota, exclua a NF de Origem da mesma.", "NF de Transferência")
	Else

		//////////////////////////////////////////////
		// Verifico se esta amarrada a uma comissao //
		//////////////////////////////////////////////
		c_ChaveNFE := SF1->(F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA)
		
		DbSelectArea("SE3")
		DbOrderNickName("XCHVNFE") //E3_FILIAL, E3_XCHVNFE, R_E_C_N_O_, D_E_L_E_T_
		If DbSeek(xFilial("SE3")+c_ChaveNFE, .F.)
			l_Ret := .F.
			MsgStop("Não é possível excluir essa pré-nota pois a mesma foi gerada através do processo de comissões. Por favor, contate o departamento Comercial.", "NF Pagto Comissão")
		Endif

	Endif
EndIf

If l_Ret
	If !Empty(SD1->D1_TES)

		DbSelectArea("SE2")
		DbSetOrder(6)//E2_FILIAL, E2_FORNECE, E2_LOJA, E2_PREFIXO, E2_NUM, E2_PARCELA, E2_TIPO, R_E_C_N_O_, D_E_L_E_T_
		If DbSeek(xFilial("SE2") + SF1->(F1_FORNECE + F1_LOJA + F1_FILIAL + LEFT(F1_SERIE,1) + F1_DOC))  
			While( SE2->(!Eof()) .And.((xFilial("SE2") + SF1->(F1_FORNECE + F1_LOJA + F1_FILIAL + LEFT(F1_SERIE,1) + F1_DOC)) == SE2->( E2_FILIAL + E2_FORNECE + E2_LOJA + E2_PREFIXO + E2_NUM )))
							
				If !Empty(SE2->E2_DATALIB)
					l_Ret := .F.
					MsgStop("Este documento já foi liberado para pagamento, primeiro deve-se estorna-lo para então prosseguir com a exlusão da nota fiscal."+cCRLF+;
							"Favor entrar em contato com o departamento de Contabilidade.","A-T-E-N-Ç-Ã-O")
					Exit
				EndIf
				
				SE2->(DbSkip())
			EndDo
		EndIf

	EndIf
EndIf

///////////////////////////////////////////////////////////////////////////////////////////////////////
//   FAZ ESTORNO DE SALDO DOS PEDIDOS DE COMPRA QUANDO NOTA FISCAL FOR ESTORNADA A CLASSIFICACAO     //
///////////////////////////////////////////////////////////////////////////////////////////////////////

If l_Ret
	If Alltrim(SF1->F1_TIPO) == "N"

			_cFilNota := SF1->F1_FILIAL
			_cNota    := SF1->F1_DOC
			_cSerie   := SF1->F1_SERIE
			_cCodFor  := SF1->F1_FORNECE
			_cLoja    := SF1->F1_LOJA
			_cTpNF    := SF1->F1_TIPO
			c_EOL := Chr(13)+Chr(10)
			
			c_Query := "SELECT D1_FILIAL,D1_DOC,D1_SERIE,D1_PEDIDO,D1_ITEMPC,D1_COD,D1_QUANT FROM "+RETSQLNAME("SD1")+" SD1 (NOLOCK) "+c_EOL
			c_Query += "WHERE "+c_EOL
			c_Query += "SD1.D1_FILIAL = '"+_cFilNota+"' AND "+c_EOL
			c_Query += "SD1.D1_DOC = '"+_cNota+"' AND "+c_EOL
			c_Query += "SD1.D1_SERIE = '"+_cSerie+"' AND "+c_EOL
			c_Query += "SD1.D1_FORNECE = '"+_cCodFor+"' AND "+c_EOL
			c_Query += "SD1.D1_LOJA = '"+_cLoja+"' AND "+c_EOL
			c_Query += "SD1.D1_TIPO = '"+_cTpNF+"' AND "+c_EOL
			c_Query += "SD1.D_E_L_E_T_ = '' "+c_EOL

			If Select("TRR")>0
				DbSelectArea("TRR")
				TRR->(DbCloseArea())
			Endif
			
			Memowrite("sqlexcpc2.sql",c_query)
		
			TcQuery c_Query NEW ALIAS "TRR"
			DbSelectArea("TRR")
			TRR->(DbGoTop())
			
			While TRR->(!Eof()) .AND. !EMPTY(TRR->D1_PEDIDO) .AND. !EMPTY(TRR->D1_ITEMPC) .AND. TRR->D1_QUANT == 0
				DbSelectArea("SC7")
				DbSetOrder(4)
				IF Dbseek(xFilial("SC7")+TRR->(D1_COD+D1_PEDIDO+D1_ITEMPC))
					RecLock("SC7",.F.)
					SC7->C7_QUJE    := 0
					SC7->C7_EMITIDO := ""
					SC7->C7_ENCER   := ""
					SC7->C7_QTDSOL  := SC7->C7_QUANT 
					
					If IsInCallStack("A140ESTCLA") == .F.
						SC7->C7_QTDACLA := 0
					Endif
					
					SC7->(MsUnlock())
			EndIf
			SC7->(dbCloseArea())
			TRR->(dbSkip())
		EndDo
		TRR->(dbCloseArea()) 
	EndIf
EndIf

//Nao colocar validacao a partir daqui, pois a condicao anterior faz atualizacao no SC7.

//CH 74524 - LOG
U_GrvLogFunc("A140EXC", a_VarsLog)

RestArea(a_AreaATU)

Return(l_Ret)


/******************************************************************************************************************************/

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³fPCFExclui³ Autor ³Felipe Azevedo dos Reis³ Data ³ 12/01/16 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Verifica se a pre nota pode ser excluida do PC-Factory.    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function fPCFExclui()

Local l_Ret	  := .T.	
Local c_Query := ""
Local c_EOL   := Chr(13) + Chr(10)
Local c_BDPCF := ""
Private c_TipoAmb	:= Upper(AllTrim(GetSrvProfString("TipoAmbienteGDC", "TESTE"))) //Se não encontrar a chave, considera que é um ambiente de Teste

//Trata tabela do ambiente de PRODUCAO e ambiente TESTE do PC-Factory, pois eles estao no mesmo BD.
If ( c_TipoAmb == "PRODUCAO" )
	c_BDPCF := GetMv("MV_XINPCFP")
Else
	c_BDPCF := GetMv("MV_XINPCFT")
EndIf

c_Query := "SELECT Sum(Qty) as QTY" + c_EOL
c_Query += "FROM "+c_BDPCF+".dbo.TBLOutInteg" + c_EOL
c_Query += "WHERE MovTypeCode in ('002','502')" + c_EOL
c_Query += "AND AuxField1 = '"+SF1->F1_DOC+"' + '/' + '"+IIf(Empty(SF1->F1_SERIE),"XXX",SF1->F1_SERIE)+"'" + c_EOL
c_Query += "AND CompanyCode = '"+SF1->F1_FORNECE+"' + '"+SF1->F1_LOJA+"'" + c_EOL

If Select("QRY") > 0
	QRY->(DbCloseArea())
Endif

TcQuery c_Query New Alias "QRY"

If QRY->(!EOF())
	If QRY->QTY <> 0
		If SF1->F1_FORMUL <> "S"
			MsgStop("Não é possível excluir essa pré-nota pois já existem descarregamentos no PC-Factory.", "A T E N C A O")
			l_Ret := .F.	
        Else
            l_Ret := MsgYesNo("***ATENÇÃO*** Por se tratar de uma nota fiscal com formulário próprio, será permitida a exclusão, mas é obrigatório o estorno do descarregamento no PC-Factory. Deseja continuar com a exclusão?", "A T E N C A O")
        EndIf		
	EndIf
EndIf

If Select("QRY") > 0
	QRY->(DbCloseArea())
Endif

Return l_Ret

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ fRetStXMLºAutor  ³ Augusto Ribeiro	 º Data ³  23/03/2010 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ IMPORTA NF-e | Retorna Status de importacao do XML         º±±
±±º          ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function fRetStXML()
	Local aArea := GetArea()
	
	IF !EMPTY(SF1->F1_CHVNFE)
		aAreaZ10	:= Z10->(GetArea())
		
		DBSELECTAREA("Z10")
		Z10->(DBSETORDER(1))	//| Z10_FILIAL, Z10_CHVNFE, Z10_TIPARQ, R_E_C_N_O_, D_E_L_E_T_
		IF Z10->(DBSEEK(XFILIAL("Z10")+SF1->F1_CHVNFE+"E",.F.))
			
			RECLOCK("Z10",.F.)
			Z10->Z10_STATUS	:= "1"
			Z10->Z10_DTSE := STOD("19000101")
			Z10->Z10_LOGINT := ""
			MSUNLOCK()
			
			/*----------------------------------------
				30/04/2019 - Jonatas Oliveira - Compila
				Atualiza Motor Fiscal
			------------------------------------------*/
			U_CP01MFST(Z10->Z10_CNPJ, Z10->Z10_CHVNFE, "INTEGRADO", IIF( ALLTRIM(Z10->Z10_TIPARQ) == "C", "CTE", "NFE" ))
					
		ELSEIF Z10->(DBSEEK(XFILIAL("Z10")+SF1->F1_CHVNFE+"C",.F.))
			
			RECLOCK("Z10",.F.)
			Z10->Z10_STATUS	:= "1"
			Z10->Z10_DTSE 	:= STOD("19000101")
			Z10->Z10_LOGINT := ""
			MSUNLOCK()
			
			/*----------------------------------------
				30/04/2019 - Jonatas Oliveira - Compila
				Atualiza Motor Fiscal
			------------------------------------------*/
			U_CP01MFST(Z10->Z10_CNPJ, Z10->Z10_CHVNFE, "INTEGRADO" , IIF( ALLTRIM(Z10->Z10_TIPARQ) == "C", "CTE", "NFE" ))
					
		ENDIF
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Remove campo SYP caso exista dados  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		IF !EMPTY(SF1->F1_XCNFOBS)
			MSMM(SF1->F1_XCNFOBS,,,,2,,,"SF1","F1_XCNFOBS")
		ENDIF
		
		RestArea(aAreaZ10)
	ENDIF
	
	IF !EMPTY(SF1->F1_XCNFOBS)
		MSMM(SF1->F1_XCNFOBS,,,,2,,,"SF1","F1_XCNFOBS")
	ENDIF
	
	RestArea(aArea)
	
Return()
