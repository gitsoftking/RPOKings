#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

#DEFINE DTMES	1
#DEFINE DIA		2
#DEFINE SEMANA	3

/*ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ M460FIM  ³ Autor ³ Claudio Dias Jr.      ³ Data ³ 27/05/09 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ P.E. utilizado na fim da geracao das NFS.                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nil => Nenhum                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nil => Nenhum                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Analista Resp.³  Data  ³ Manutencao Efetuada                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Claudio D.Jr. ³27/05/09³Chamado[3183] - Tratar gravacao do Frete/Segu- ³±±
±±³              ³        ³ro/Despesas para ratear em diversas notas.     ³±±
±±³Daniel G.Jr.  ³19/04/10³Chamado[    ] - Ajuste na query, pois o filtro ³±±
±±³              ³        ³estava incorreto                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Felipe Aguiar ³06/01/12³Chamado 15709 - Comentado a validacao no campo ³±±
±±³				 ³		  ³	ZX5_MSBLQD pois estava diferente do fonte.	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Felipe Reis   ³28/01/12³Chamado 36632 - Projeto rastreabilidade.       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Claudio Dias  ³03/12/15³Chamado : 58452 - Mexendo na Função fCalculo   ³±±
±±³              ³        ³Fazendo posicionamento na tabela SF2           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Ewerton H. Coz³15/01/16³Chamado : 59230 - Enviar WK quando faturar nota³±±
±±³              ³        ³para consumidor Final - Chamado fSndNf2Cf      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Felipe Reis   ³12/01/16³ 3a Fase do projeto de Rastreabilidade.    	  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Ewerton H. Coz³06/07/16³ Alteração da regra criada no chamado 44041    ³±±
±±³              ³        ³tratada no chamado 62705(Notas Compl/Norm)     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Ewerton H. Coz³15/03/17³ #67370 Envio do informativo para as áreas com ³±±
±±³              ³        ³ incentivo que são AC, AM, AP, RO, RR          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Felipe Aguiar ³29/03/17³Chamado 68187: Inclusao da Guia no email PIM   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Felipe Reis   ³25/07/19³Chamado 89196: Condicao de pagamento especial. ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function M460FIM()

Local a_AreaATU := GetArea()
//CH 74524 - LOG
Local a_VarsLog	:= {MsDate(), Time(), ""} //[1]-Data; [2]-Hora; [3]-Observacao

Local a_AreaSF2 := SF2->(GetArea())
Local a_AreaSD2 := SD2->(GetArea())
Local a_AreaSC5 := SC5->(GetArea())
Local a_AreaSE1 := SE1->(GetArea())
Local a_AreaPA2	:= PA2->(GetArea())
Local a_AreaZZW	:= ZZW->(GetArea())
Local a_DadosDest := {}
Local c_EstPIM	:= GetMV("MV_XESTZF")
Local c_MunPIM	:= GetMV("MV_XMUNZF")

Local lImpNFE 	:= GetMv("MV_XMLIMP",.F.,.F.) //| IMPORDOR XML COMPILA |
Local _aArea	:=	GetArea() //| IMPORDOR XML COMPILA|

Private n_BaseIcm 	:= 0
Private n_ValIcm 	:= 0
Private n_ValFecp 	:= 0
Private n_Difal 	:= 0
Private n_IcmsCom 	:= 0

/*--------------------------
	IMPORDOR XML COMPILA
---------------------------*/
IF lImpNFE
	DBSELECTAREA("Z10")
	Z10->(DBSETORDER(1))
	IF Z10->(DBSEEK(XFILIAL("Z10")+SC5->C5_XCHVNFE +"S")) //.and. !EMPTY(SC5->C5_XCHVNFE)
		
		DBSELECTAREA("Z10")
		RECLOCK("Z10",.F.)
			Z10->Z10_STATUS	:= "5"
		MSUNLOCK()
		
		cNota	:= Z10->Z10_NUMNFE
		cSerie	:= Z10->Z10_SERIE
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Grava informacoes adicionais para compatibilidade com SPEDs³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		DBSELECTAREA("SF2")
		SF2->(DBSETORDER(1)) //| F2_FILIAL, F2_DOC, F2_SERIE, F2_CLIENTE, F2_LOJA, F2_FORMUL, F2_TIPO
		IF SF2->(DBSEEK(XFILIAL("SF2")+cNota+cSerie))
			RECLOCK("SF2",.F.)
			SF2->F2_CHVNFE	:= Z10->Z10_CHVNFE
			SF2->(MSUNLOCK())
							
			DBSELECTAREA("SF3")
			SF3->(DBSETORDER(5)) //| F3_FILIAL, F3_SERIE, F3_NFISCAL, F3_CLIEFOR, F3_LOJA, F3_IDENTFT, R_E_C_N_O_, D_E_L_E_T_
			IF SF3->(DBSEEK(SF2->(F2_FILIAL+F2_SERIE+F2_DOC+F2_CLIENTE+F2_LOJA)))
				RECLOCK("SF3",.F.)
				SF3->F3_CHVNFE	:= Z10->Z10_CHVNFE
				SF3->(MSUNLOCK())
			ENDIF
			
			DBSELECTAREA("SFT")
			SFT->(DBSETORDER(1)) //| FT_FILIAL, FT_TIPOMOV, FT_SERIE, FT_NFISCAL, FT_CLIEFOR, FT_LOJA, FT_ITEM, FT_PRODUTO
			IF SFT->(DBSEEK(SF2->(F2_FILIAL+"S"+F2_SERIE+F2_DOC+F2_CLIENTE+F2_LOJA)))
				WHILE SFT->(!EOF()) .AND. SF2->(F2_FILIAL+"S"+F2_SERIE+F2_DOC+F2_CLIENTE+F2_LOJA) == SFT->(FT_FILIAL+FT_TIPOMOV+FT_SERIE+FT_NFISCAL+FT_CLIEFOR+FT_LOJA)
					RECLOCK("SFT",.F.)
					SFT->FT_CHVNFE	:= Z10->Z10_CHVNFE
					SFT->(MSUNLOCK())
					SFT->(DBSKIP())
				ENDDO
			ENDIF								
		ENDIF
	ENDIF
ENDIF
RestArea(_aArea)


//PROVISORIO - Excluir titulo de ISS zerado
U_fElimISSZero(SF2->F2_PREFIXO, SF2->F2_DOC, SF2->F2_EMISSAO)

//Tratamento novo para rotina de ordem de separacao para filial 20 embalagem  
//Emerson  QS
If cEmpAnt == '03' .AND. cFilant $ ('20|05')
	DbSelectArea("ZBB")
	DbSetOrder(3)//ZBB_FILIAL+ZBB_PEDIDO+ZBB_NOTA
	If DbSeek(xFilial("ZBB")+SD2->D2_PEDIDO) //Numero do Pedido
		
		cOrdSepp := ZBB->ZBB_ORDSEP
		
		If !Empty(SF2->F2_DOC) .And. !Empty(SD2->D2_PEDIDO)
			//Efetua a gravacao na tabela ZBB o Status e Nota
			cQuery :=" Update "+RetSqlName('ZBB')+" Set ZBB_STATUS='F', ZBB_NOTA='"+SF2->F2_DOC+"', ZBB_DATFAT='"+DTOS(dDataBase)+"' "
			cQuery +=" WHERE ZBB_FILIAL='"+xFilial('ZBB')+"' AND ZBB_PEDIDO='"+SD2->D2_PEDIDO+"' and D_E_L_E_T_=' '"
			TcSqlExec(cQuery)
			
			Aviso('Aviso','Gravado numero da nota: ' + SF2->F2_DOC + ' na ordem de separacao: ' + cOrdSepp + '.', {"OK"})
		Else
			Aviso('Aviso','Não foi possível atualizar os dados da ordem de separação: ' + cOrdSepp + '.', {"OK"})
		EndIf
	EndIf
EndIf      
//Emerson QS
////////////////////////////////

//- Chama funcao para decobrir valores do cabecalho da nota ---------------------------------------------------
fCalculo()
//-------------------------------------------------------------------------------------------------------------

//- Funcao para calcular a data de pagamento customizada
If GetMV("MV_XCUSCOM")
	fCondPagto()
EndIf
//-------------------------------------------------------------------------------------------------------------

//Verifica se o Faturamento e para o cliente ESPABRA e envia e-mail ao financeiro (Chamado 44041) - Alteração da Regra - 62705
If AllTrim(SF2->F2_CLIENTE) $ "304707#404787#000142" 
	If AllTrim(SF2->F2_TIPO) == "N" .And. AllTrim(SF2->F2_CLIENTE) == "304707"
		U_FWKLFATCLI(1)
	ElseIf AllTrim(SF2->F2_CLIENTE) == "404787" .And. AllTrim(SF2->F2_TIPO) $ "N#C"
		U_FWKLFATCLI(2)
	ElseIf AllTrim(SF2->F2_TIPO) == "N" .And. AllTrim(SF2->F2_CLIENTE) == "000142"
		U_FWKLFATCLI(3)
	EndIf
EndIf

//Funcao que verifica se o cliente é consumidor final//

DbSelectArea("SA1")
DbSetOrder(1)//A1_COD, A1_LOJA, D_E_L_E_T_
If DbSeek(xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA)
		If AllTrim(SA1->A1_TIPO) == "F" .And. (Left(SA1->A1_INSCR,5) = "ISENT") .Or. Empty(SA1->A1_INSCR) //Consumidor final
    	fSndNf2Cf()
    EndIf
EndIF

//Verifica se o estado do pedido é de áreas incentivadas #67370
If (AllTrim(SC5->C5_EST) $ c_EstPIM) .And. (AllTrim(Upper(SA1->A1_MUN)) $ c_MunPIM)
	fAreaPIM()
EndIf

//Ch. 93158 - Verifica se o estado do pedido é MT.
If AllTrim(SF2->F2_EST) == "MT"
	fEstMT()
End

a_DadosDest := u_fGetDestCli(SF2->F2_FILIAL, SF2->F2_TIPO, SF2->F2_LOJA)

//Envia pre nota para o PC-Factory
U_ExpNFEPCF({SF2->F2_DOC, SF2->F2_SERIE, a_DadosDest[1], a_DadosDest[2], '1', a_DadosDest[4]})	

//Envia e-mail caso valor da carga ultrapasse o estipulado
U_GEVlMax()

//-------------------------------------------------------------------------------------------------------------

//CH 74524 - LOG
U_GrvLogFunc("M460FIM", a_VarsLog)

RestArea(a_AreaSC5)
RestArea(a_AreaZZW)
RestArea(a_AreaPA2)
RestArea(a_AreaSE1)
RestArea(a_AreaSD2)
RestArea(a_AreaSF2)
RestArea(a_AreaATU)

Return(.T.)

//*************************************************************************************************************

/*ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ fCalculo ³ Autor ³ Claudio Dias Jr.      ³ Data ³ 27/05/09 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Funcao para descobrir valores do Frete, Seguro, Despesa.   ³±±
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

Static Function fCalculo()

Local 	c_Query 	:= ""

//------------------------------------------------ QUERY -------------------------------------------------------
c_Query := "SELECT "
c_Query += "SUM(D2_VALFRE) AS VALFRE, "
c_Query += "SUM(D2_SEGURO) AS VALSEG, "
c_Query += "SUM(D2_DESPESA) AS VALDES "
c_Query += "FROM "+RetSqlName("SD2")+" AS SD2 (NOLOCK) "
c_Query += "WHERE D2_DOC = '"+SD2->D2_DOC+"' "
//-------  Ajuste no filtro da query  (em 19/04/2010 por Daniel G.Jr.)  ----- INÍCIO
c_Query += "AND D2_SERIE = '"+SD2->D2_SERIE+"' "
c_Query += "AND D2_FILIAL = '"+SD2->D2_FILIAL+"' "
c_Query += "AND D2_CLIENTE = '"+SD2->D2_CLIENTE+"' "
c_Query += "AND D2_LOJA = '"+SD2->D2_LOJA+"' "
//------- FINAL
c_Query += "AND SD2.D_E_L_E_T_ = ' ' "
//---------------------------------------------------------------------------------------------------------------

If Select("RSDNF") > 0
	RSDNF->(DbCloseArea())
Endif

//- Executa Query
TcQuery c_Query New Alias "RSDNF"

//- Atualiza o cabecalho da nota fiscal com a soma do SD2 rateado -----------------------------------------------

DbSelectArea("SF2")
DbSetOrder(1) // F2_FILIAL, F2_DOC, F2_SERIE, F2_CLIENTE, F2_LOJA, F2_FORMUL, F2_TIPO, R_E_C_N_O_, D_E_L_E_T_
DbGoTop()
If DbSeek(SD2->(D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA), .F.)
RecLock("SF2",.F.)
SF2->F2_FRETE 		:= RSDNF->VALFRE
SF2->F2_SEGURO		:= RSDNF->VALSEG
SF2->F2_DESPESA 	:= RSDNF->VALDES
MsUnLock()
EndIf

//---------------------------------------------------------------------------------------------------------------

RSDNF->(DbCloseArea())

Return Nil

//*************************************************************************************************************

/*ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³fCondPagto³ Autor ³Felipe Azevedo dos Reis³ Data ³ 17/08/11 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Funcao para calcular a forma de pagamento customizada.     ³±±
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
Static Function fCondPagto()

Local d_DtVenc	:= CtoD("//")

//Verifica se nao utiliza fornecedor e se gera duplicata (SE1)
If !(SC5->C5_TIPO $ "B#D") //.And. SF4->F4_DUPLIC == "S"
	dbSelectArea("SE1")
	dbSetOrder(2) //E1_FILIAL, E1_CLIENTE, E1_LOJA, E1_PREFIXO, E1_NUM, E1_PARCELA, E1_TIPO, R_E_C_N_O_, D_E_L_E_T_
	If SE1->(dbseek(xFilial("SE1")+SF2->(F2_CLIENTE+F2_LOJA+F2_PREFIXO+F2_DOC),.F.))
		//Verifica se o cliente esta cadastrado com a condicao de pagamento especial (dias da semana)
		If fBuscaZX5()
			//A configucao do cliente x condicao de pagamento por dia da semana nao pode estar bloqueada
			If (ZX5->ZX5_MSBLQL <> '1') //- Alterado por Felipe Aguiar - Chamado 15709 -
				While SE1->(!Eof()) .And. xFilial("SE1")+SE1->(E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM) == xFilial("SE1")+SF2->(F2_CLIENTE+F2_LOJA+F2_PREFIXO+F2_DOC)
					d_DtVenc := u_fDtVencto(SE1->E1_VENCREA)
					If (d_DtVenc <> SE1->E1_VENCREA) .And. !(SE1->E1_SALDO <= 0)
						Begin Transaction
							//Grava a instrução bancaria
							RecLock("SZA",.T.)
							SZA->ZA_PREFIXO	:= SE1->E1_PREFIXO
							SZA->ZA_NUM 	:= SE1->E1_NUM
							SZA->ZA_PARCELA	:= SE1->E1_PARCELA
							SZA->ZA_TIPO 	:= SE1->E1_TIPO
							SZA->ZA_CLIENTE	:= SE1->E1_CLIENTE
							SZA->ZA_LOJA 	:= SE1->E1_LOJA
							SZA->ZA_NOMECLI	:= SE1->E1_NOMCLI
							SZA->ZA_EMISSAO	:= SE1->E1_EMISSAO
							SZA->ZA_VENCTO 	:= SE1->E1_VENCTO
							SZA->ZA_VENCREA	:= SE1->E1_VENCREA
							SZA->ZA_VALOR 	:= SE1->E1_VALOR
							SZA->ZA_DATAINS := MsDate()
							SZA->ZA_SEQ 	:= "01"
							SZA->ZA_INSTRUC	:= "000001"
							SZA->ZA_COMPLEM	:= DtoC(d_DtVenc)
							SZA->ZA_XXXXXXX := DtoC(d_DtVenc)
							SZA->ZA_MOTIVO 	:= "98"
							SZA->ZA_AUTORIZ	:= "SISTEMA"
							SZA->ZA_HRINSTR := Substr(Time(),1,5)
							SZA->ZA_ENVIA   := "2"
							SZA->ZA_XMARCA  := "2"
							SZA->ZA_XDATE   := MsDate()
							SZA->ZA_XORIGEM := "M460FIM"
							MsUnlock()
							
							//Atualiza a data de vencimento no contas a receber
							RecLock("SE1",.F.)
							SE1->E1_VENCREA	:= d_DtVenc
							SE1->E1_VENCTO	:= d_DtVenc
							MsUnlock()
							
							//Atualiza a data de vencimento no log
							ZZW->(dbSelectArea("ZZW"))
							ZZW->(dbSetOrder(1))//ZZW_FILIAL, ZZW_ENTORI, ZZW_RECORI, ZZW_ORDEM, R_E_C_N_O_, D_E_L_E_T_
							If ZZW->(dbSeek(xFilial("ZZW")+"SE1"+SE1->E1_MSIDENT+"3.2",.F.))
								RecLock("ZZW",.F.)
								ZZW->ZZW_DATA := d_DtVenc
								MsUnlock()
							EndIf
						End Transaction
					EndIf
					
					SE1->(dbSkip())
						
				EndDo
			
			EndIf
				
		EndIf
			
	EndIf
		
EndIf
	
Return(Nil)

//*************************************************************************************************************

/*ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³fDtVencto ³ Autor ³Felipe Azevedo dos Reis³ Data ³ 17/08/11 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Funcao para calcular a forma de pagamento customizada.     ³±±
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

User Function fDtVencto(d_Data)

Local d_Ret 	:= d_Data
Local d_DtIni1	:= FirstDate(d_Data)	//Primeiro dia do mes
Local d_DtFim1	:= LastDate(d_Data) 	//Ultimo dia do mes
Local d_DtIni2	:= d_DtFim1+1			//Primeiro dia do mes subsequente
Local d_DtFim2	:= LastDate(d_DtIni2)	//Ultimo dia do mes subsequente
Local d_DtIni3	:= d_DtFim2+1			//Primeiro dia do mes subsequente + 1
Local d_DtFim3	:= LastDate(d_DtIni3)	//Ultimo dia do mes subsequente + 1
Local a_SeqSem	:= {}
Local a_SemFil	:= {}
Local n_semana	:= 1
Local l_RetPA2  := .F.
Local n_IniSem	:= 1
Local n_IniSem	:= 1
Local a_Dia		:= {}
Local a_Semana	:= {}
Local a_Aux1    := {}
Local a_Aux2    := {}
Local a_CondMes := {}

If ZX5->ZX5_CNDPD == "1"

    //Monta array com a regra de datas
    a_Aux1 := StrTokArr2(ZX5->ZX5_REGRA,";",.F.)
	For i := 1 To Len(a_Aux1)
		If !Empty(a_Aux1[i])
			a_Aux2 := StrTokArr2(a_Aux1[i],",")	
			AAdd(a_CondMes,{a_Aux2[1],a_Aux2[2],a_Aux2[3],a_Aux2[4]})
		EndIf
	Next i     
 
    //Verifica se cai na regra
    For i := 1 to Len(a_CondMes)
        If Day(d_Data) >= Val(a_CondMes[i][1]) .And. Day(d_Data) <= Val(a_CondMes[i][2])
            If a_CondMes[i][4] == "1"
                d_Ret := DataValida(StoD(Left(DtoS(d_DtIni1-1),6)  + StrZero(Val(a_CondMes[i][3]),2)))
            ElseIf a_CondMes[i][4] == "2"                
				d_Ret := DataValida(StoD(Left(DtoS(d_Data),6)  + StrZero(Val(a_CondMes[i][3]),2)))
            ElseIf a_CondMes[i][4] == "3"
                d_Ret := DataValida(StoD(Left(DtoS(d_DtFim1+1),6) + StrZero(Val(a_CondMes[i][3]),2)))
            EndIf
            Exit
        EndIf
    Next i

Else

    For i := 1 To 7
        AAdd(a_Dia, IIf( &("ZX5->ZX5_VENC"+AllTrim(Str(i))) == "S", .T., .F.))
    Next i

    For i := 1 To 5
        AAdd(a_Semana, IIf( SubStr(ZX5->ZX5_SEMANA,i,1) == "X", .T., .F.))
    Next i

    n_IniSem := IIf(Dow(d_DtIni1) == 1, 7, Dow(d_DtIni1) - 1)

    //Percorre o mes corrente
    While d_DtIni1 <= d_DtFim1
        
        AAdd(a_SeqSem,{d_DtIni1, Dow(d_DtIni1), n_semana})
        
        If Dow(d_DtIni1) ==  n_IniSem		
            n_semana ++
        EndIf
        
        d_DtIni1 := d_DtIni1 + 1
        
    EndDo

    n_semana := 1
    n_IniSem := IIf(Dow(d_DtIni2) == 1, 7, Dow(d_DtIni2) - 1)

    //Percorre o mes subsequente
    While d_DtIni2 <= d_DtFim2
        
        AAdd(a_SeqSem,{d_DtIni2, Dow(d_DtIni2), n_semana})
        
        If Dow(d_DtIni2) == n_IniSem 		
            n_semana ++
        EndIf
        
        d_DtIni2 := d_DtIni2 + 1
        
    EndDo

    n_semana := 1
    n_IniSem := IIf(Dow(d_DtIni3) == 1, 7, Dow(d_DtIni3) - 1)

    //Percorre o mes subsequente + 1
    While d_DtIni3 <= d_DtFim3
        
        AAdd(a_SeqSem,{d_DtIni3, Dow(d_DtIni3), n_semana})
        
        If Dow(d_DtIni3) == n_IniSem		
            n_semana ++
        EndIf
        
        d_DtIni3 := d_DtIni3 + 1
        
    EndDo

    PA2->(DbSelectArea("PA2"))
    PA2->(DbGoTop())

    //Filtro a data conforme regras passadas por parametro
    For i := 1 to Len(a_SeqSem)

        If a_Dia[a_SeqSem[i][DIA]] .And. a_Semana[a_SeqSem[i][SEMANA]]
        
            //Verifico se e data valida
            If DataValida(a_SeqSem[i][DTMES]) == a_SeqSem[i][DTMES]
            
                //Verifico cadastro de feriado PA2
                While PA2->(!Eof())
                    
                    If Empty(PA2->PA2_EXCES) .Or. PA2->PA2_EXCES == Left(DtoS(a_SeqSem[i][DTMES]),4)
                        If Left(PA2->PA2_PERIOD,2) == Right(DtoS(a_SeqSem[i][DTMES]),2) .And. SubStr(PA2->PA2_PERIOD,4,2) == SubStr(DtoS(a_SeqSem[i][DTMES]),5,2)
                            l_RetPA2 := .T.
                            Exit
                        EndIf
                    EndIf

                    PA2->(DbSkip())
                EndDo
                
                If !l_RetPA2
                    aAdd(a_SemFil,a_SeqSem[i][DTMES])
                EndIf
                
            EndIf	 
        EndIf

    Next i

    //Procuro a proxima data valida
    For i := 1 to Len(a_SemFil)
        If d_Data <= a_SemFil[i]
            d_Ret := a_SemFil[i]
            Exit
        EndIf
    Next i

EndIf

Return d_Ret

//*************************************************************************************************************

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    | fSndNf2Cf ³ Autor ³ Ewerton H. Cozaciuc  ³ Data ³ 12/01/16  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Envia email com NF faturada para NÃO CONTRIBUINTE De ICMS   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nenhum.                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nil.                                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Analista Resp.³  Data  ³ Manutencao Efetuada                            ³±±
±±³ÄÄÄÄÄÄÄÄÄÄÄÄÄÄ³ÄÄÄÄÄÄÄÄ³ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³              ³  /  /  ³                                                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function fSndNf2Cf()

Local c_Assunto	:= "Mensageiro Protheus - Nota Faturada "+SF2->F2_DOC+"/"+SF2->F2_SERIE+" para Não Contribuinte De ICMS"
Local c_HTML	:= ""

c_HTML += '<HTML><!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">'
c_HTML += '	<html xmlns="http://www.w3.org/1999/xhtml">'
c_HTML += '	<style type="text/css">'
c_HTML += '		.formulario { FONT-SIZE: 10px; COLOR: #000000; FONT-FAMILY: Verdana, Arial, Helvetica, sans-serif; TEXT-DECORATION: none; font-weight: bold; }'
c_HTML += '		.formulario2{ FONT-SIZE: 11px; COLOR: #333333; FONT-FAMILY: Verdana, Arial, Helvetica, sans-serif; TEXT-DECORATION: none; }'
c_HTML += '		.formularioTit { FONT-SIZE: 13px; COLOR: #FFFFFF; FONT-FAMILY: Verdana, Arial, Helvetica, sans-serif; TEXT-DECORATION: none; font-weight: bold; }'
c_HTML += '		.formularioTit2 { FONT-SIZE: 13px; COLOR: #000000; FONT-FAMILY: Verdana, Arial, Helvetica, sans-serif; TEXT-DECORATION: none; font-weight: bold; }'
c_HTML += '	</style>'
c_HTML += '<head>'
c_HTML += '	<title>Aviso de pedido a ser liberado</title>'
c_HTML += '</head>'

c_HTML += '<table width="95%" border="0" align="center">'
c_HTML += '<tr>'
c_HTML += '	<td colspan="11" >'
c_HTML += '		<img src="'+GetMV("MV_XLOGO")+'" border="0">'
c_HTML += '	</td>'
c_HTML += '<tr>'

c_HTML += '<tr>'
c_HTML += '	<td colspan="11" bgcolor="#0597CD">'
c_HTML += '		<div align="center"><span class="formularioTit"><h2>Aviso Eletrônico<h2></span></div>'
c_HTML += '	</td>'
c_HTML += '</tr>'
c_HTML += '<tr>'
c_HTML += '	<td colspan="11">&nbsp;</td>'
c_HTML += '</tr>'
c_HTML += '<tr>'
c_HTML += '	<td colspan="11"><span class="formularioTit2">Abaixo seguem algumas informações da Nota Fiscal que foi faturada para não contribuinte de ICMS:</span></td>'
c_HTML += '</tr>'
c_HTML += '<tr>'
c_HTML += '	<td colspan="11">&nbsp;</td>'
c_HTML += '</tr>'
c_HTML += '<tr>'
c_HTML += '	<td colspan="11" bgcolor="#0597CD"><div align="center"><span class="formulario"><h5> Inforamações da Nota Faturada<h5></span></div></td>'
c_HTML += '</tr>'
c_HTML += '<tr>'
c_HTML += '	<td colspan="11">&nbsp;</td>'
c_HTML += '</tr>'

c_HTML += '<tr>'
c_HTML += '	<td bgcolor="#ECF0EE" class="formulario">Filial</td>'
c_HTML += '	<td bgcolor="#ECF0EE" class="formulario">Nota</td>'
c_HTML += '	<td bgcolor="#ECF0EE" class="formulario">Série</td>'
c_HTML += '	<td bgcolor="#ECF0EE" class="formulario">Cliente</td>'
c_HTML += '	<td bgcolor="#ECF0EE" class="formulario">Loja</td>'
c_HTML += '	<td bgcolor="#ECF0EE" class="formulario">Estado</td>'
c_HTML += '	<td bgcolor="#ECF0EE" class="formulario">Base.ICMS</td>' //FT_BASEICM
c_HTML += '	<td bgcolor="#ECF0EE" class="formulario">Valor.ICMS</td>' //FT_VALICM
c_HTML += '	<td bgcolor="#ECF0EE" class="formulario">Valor.FECP</td>' //FT_VALFECP
c_HTML += '	<td bgcolor="#ECF0EE" class="formulario">Difal.ICMS</td>' //FT_DIFAL
c_HTML += '	<td bgcolor="#ECF0EE" class="formulario">Vlr.ICMS.Com</td>' //FT_ICMSCOM
c_HTML += '</tr>'

fSomaSFT()

c_HTML += '<tr>'
c_HTML += '	<td  bgcolor="#F7F9F8" class="formulario2">'+SF2->F2_FILIAL+'</td>'
c_HTML += '	<td  bgcolor="#F7F9F8" class="formulario2">'+SF2->F2_DOC+'</td>'
c_HTML += '	<td  bgcolor="#F7F9F8" class="formulario2">'+SF2->F2_SERIE+'</td>'
c_HTML += '	<td  bgcolor="#F7F9F8" class="formulario2">'+SF2->F2_CLIENTE+'</td>'
c_HTML += '	<td  bgcolor="#F7F9F8" class="formulario2">'+SF2->F2_LOJA+'</td>'
c_HTML += '	<td  bgcolor="#F7F9F8" class="formulario2">'+SF2->F2_EST+'</td>'
c_HTML += '	<td  bgcolor="#F7F9F8" class="formulario2">'+'R$ '+AllTrim(Transform(n_BaseIcm, "9,999,999.99"))+'</td>'
c_HTML += '	<td  bgcolor="#F7F9F8" class="formulario2">'+'R$ '+AllTrim(Transform(n_ValIcm, "9,999,999.99"))+'</td>'
c_HTML += '	<td  bgcolor="#F7F9F8" class="formulario2">'+'R$ '+AllTrim(Transform(n_ValFecp, "9,999,999.99"))+'</td>'
c_HTML += '	<td  bgcolor="#F7F9F8" class="formulario2">'+'R$ '+AllTrim(Transform(n_Difal, "9,999,999.99"))+'</td>'
c_HTML += '	<td  bgcolor="#F7F9F8" class="formulario2">'+'R$ '+AllTrim(Transform(n_IcmsCom, "9,999,999.99"))+'</td>'
c_HTML += '</tr>'

c_HTML += '<tr>'
c_HTML += '	<td class="formulario"><p>&nbsp;</p></td>'
c_HTML += '</tr>'

c_HTML += '<tr>'
c_HTML += '	<td colspan="11" bgcolor="#0597CD"><div align="center"><span class="formulario"><h5>Informática Gomes da Costa</h5></span></div></td>'
c_HTML += '</tr>'

c_HTML += '<tr>'
c_HTML += '	<td colspan="11" bgcolor="#0597CD"><div align="center"><span class="formulario"><h5>Ajudando você no seu dia-a-dia!</h5></span></div></td>'
c_HTML += '</tr>'

c_HTML += '</table>'
c_HTML += '</body>'
c_HTML += '</html>'

//Envia o E-mail
U_GDCSendMail("","",GetMV("MV_RELSERV"),"0044",c_Assunto,c_HTML,"","","")

Return Nil

/**********************************************************************************************/

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    | fAreaPIM  ³ Autor ³ Ewerton H. Cozaciuc   ³ Data ³ 12/01/16 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Envia email com NF faturada para regiões com PIM            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nenhum.                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nil.                                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Analista Resp.³  Data  ³ Manutencao Efetuada                            ³±±
±±³ÄÄÄÄÄÄÄÄÄÄÄÄÄÄ³ÄÄÄÄÄÄÄÄ³ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³              ³  /  /  ³                                                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function fAreaPIM()

Local c_Assunto	:= "Mensageiro Protheus - Nota Faturada "+SF2->F2_DOC+"/"+SF2->F2_SERIE+" para Área com Incentivo - P.I.M."
Local c_HTML	:= ""

c_HTML += '<HTML><!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">'
c_HTML += '	<html xmlns="http://www.w3.org/1999/xhtml">'
c_HTML += '	<style type="text/css">'
c_HTML += '		.formulario { FONT-SIZE: 10px; COLOR: #000000; FONT-FAMILY: Verdana, Arial, Helvetica, sans-serif; TEXT-DECORATION: none; font-weight: bold; }'
c_HTML += '		.formulario2{ FONT-SIZE: 11px; COLOR: #333333; FONT-FAMILY: Verdana, Arial, Helvetica, sans-serif; TEXT-DECORATION: none; }'
c_HTML += '		.formularioTit { FONT-SIZE: 13px; COLOR: #FFFFFF; FONT-FAMILY: Verdana, Arial, Helvetica, sans-serif; TEXT-DECORATION: none; font-weight: bold; }'
c_HTML += '		.formularioTit2 { FONT-SIZE: 13px; COLOR: #000000; FONT-FAMILY: Verdana, Arial, Helvetica, sans-serif; TEXT-DECORATION: none; font-weight: bold; }'
c_HTML += '	</style>'
c_HTML += '<head>'
c_HTML += '	<title>Aviso de pedido a ser liberado</title>'
c_HTML += '</head>'

c_HTML += '<table width="95%" border="0" align="center">'
c_HTML += '<tr>'
c_HTML += '	<td colspan="8" >'
c_HTML += '		<img src="'+GetMV("MV_XLOGO")+'" border="0">'
c_HTML += '	</td>'
c_HTML += '<tr>'

c_HTML += '<tr>'
c_HTML += '	<td colspan="8" bgcolor="#0597CD">'
c_HTML += '		<div align="center"><span class="formularioTit"><h2>Aviso Eletrônico<h2></span></div>'
c_HTML += '	</td>'
c_HTML += '</tr>'
c_HTML += '<tr>'
c_HTML += '	<td colspan="8">&nbsp;</td>'
c_HTML += '</tr>'
c_HTML += '<tr>'
c_HTML += '	<td colspan="12"><span class="formularioTit2">Abaixo segue algumas informações da Nota Faturada para a Área de Incentivo</span></td>'
c_HTML += '</tr>'
c_HTML += '<tr>'
c_HTML += '	<td colspan="8">&nbsp;</td>'
c_HTML += '</tr>'
c_HTML += '<tr>'
c_HTML += '	<td colspan="8" bgcolor="#0597CD"><div align="center"><span class="formulario"><h5> Inforamações da Nota Faturada<h5></span></div></td>'
c_HTML += '</tr>'
c_HTML += '<tr>'
c_HTML += '	<td colspan="8">&nbsp;</td>'
c_HTML += '</tr>'

c_HTML += '<tr>'
c_HTML += '	<td bgcolor="#ECF0EE" class="formulario">Filial</td>'
c_HTML += '	<td bgcolor="#ECF0EE" class="formulario">Nota</td>'
c_HTML += '	<td bgcolor="#ECF0EE" class="formulario">Série</td>'
c_HTML += '	<td bgcolor="#ECF0EE" class="formulario">Cliente</td>'
c_HTML += '	<td bgcolor="#ECF0EE" class="formulario">Loja</td>'
c_HTML += '	<td bgcolor="#ECF0EE" class="formulario">Estado</td>'
c_HTML += '	<td bgcolor="#ECF0EE" class="formulario">Município</td>'
c_HTML += '	<td bgcolor="#ECF0EE" class="formulario">Guia de Embarque</td>'
c_HTML += '</tr>'

c_HTML += '<tr>'
c_HTML += '	<td  bgcolor="#F7F9F8" class="formulario2">'+SF2->F2_FILIAL+'</td>'
c_HTML += '	<td  bgcolor="#F7F9F8" class="formulario2">'+SF2->F2_DOC+'</td>'
c_HTML += '	<td  bgcolor="#F7F9F8" class="formulario2">'+SF2->F2_SERIE+'</td>'
c_HTML += '	<td  bgcolor="#F7F9F8" class="formulario2">'+SF2->F2_CLIENTE+'</td>'
c_HTML += '	<td  bgcolor="#F7F9F8" class="formulario2">'+SF2->F2_LOJA+'</td>'
c_HTML += '	<td  bgcolor="#F7F9F8" class="formulario2">'+SF2->F2_EST+'</td>'
c_HTML += '	<td  bgcolor="#F7F9F8" class="formulario2">'+SA1->A1_MUN+'</td>'
c_HTML += '	<td  bgcolor="#F7F9F8" class="formulario2">'+SF2->F2_XGSAIDA+'</td>'
c_HTML += '</tr>'

c_HTML += '<tr>'
c_HTML += '	<td class="formulario"><p>&nbsp;</p></td>'
c_HTML += '</tr>'

c_HTML += '<tr>'
c_HTML += '	<td colspan="8" bgcolor="#0597CD"><div align="center"><span class="formulario"><h5>Informática Gomes da Costa</h5></span></div></td>'
c_HTML += '</tr>'

c_HTML += '<tr>'
c_HTML += '	<td colspan="8" bgcolor="#0597CD"><div align="center"><span class="formulario"><h5>Ajudando você no seu dia-a-dia!</h5></span></div></td>'
c_HTML += '</tr>'

c_HTML += '</table>'
c_HTML += '</body>'
c_HTML += '</html>'

U_GDCSendMail("","",GetMV("MV_RELSERV"),"0142",c_Assunto,c_HTML,"","","")

Return Nil
/**********************************************************************************************/

/*ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ fCalculo ³ Autor ³ E. H. Cozaciuc        ³ Data ³ 26/06/17 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Funcao para somar os itens dos livros fiscais - SFT        ³±±
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

Static Function fSomaSFT()

Local 	c_Query 	:= ""

c_Query := "SELECT SUM(FT_BASEICM) AS 'BASEICM', "
c_Query += "	   SUM(FT_VALICM) AS 'VALICM', "
c_Query += "	   SUM(FT_VALFECP) AS 'VALFECP', "
c_Query += "	   SUM(FT_DIFAL) AS 'DIFAL', "
c_Query += "	   SUM(FT_ICMSCOM) AS 'ICMSCOM' "
c_Query += "FROM "+RetSqlName("SFT")+" AS SFT (NOLOCK) "
c_Query += "WHERE FT_FILIAL = '"+SF2->F2_FILIAL+"' "
c_Query += "AND FT_TIPOMOV = 'S' "
c_Query += "AND FT_SERIE = '"+SF2->F2_SERIE+"' "
c_Query += "AND FT_NFISCAL = '"+SF2->F2_DOC+"' "
c_Query += "AND FT_CLIEFOR = '"+SF2->F2_CLIENTE+"' "
c_Query += "AND FT_LOJA = '"+SF2->F2_LOJA+"' "
c_Query += "AND SFT.D_E_L_E_T_ = ' ' "

If Select("SUMFT") > 0
	SUMFT->(DbCloseArea())
Endif

//- Executa Query
TcQuery c_Query New Alias "SUMFT"

n_BaseIcm 	:= SUMFT->BASEICM
n_ValIcm 	:= SUMFT->VALICM
n_ValFecp 	:= SUMFT->VALFECP
n_Difal 	:= SUMFT->DIFAL
n_IcmsCom 	:= SUMFT->ICMSCOM

SUMFT->(DbCloseArea())

Return Nil

/**********************************************************************************************/

/*ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ fBuscaZX5 ³ Autor ³Felipe Azevedo Reis   ³ Data ³ 09/04/19 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Posiciona e retorna se o registro foi encontrado.          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function fBuscaZX5()

Local l_Ret := .F.

DbSelectArea("ZX5")
ZX5->(DbSetOrder(1)) //ZX5_FILIAL, ZX5_CLIENT, ZX5_LOJA, R_E_C_N_O_, D_E_L_E_T_
ZX5->(DbGoTop()) //ZX5_FILIAL, ZX5_CLIENT, ZX5_LOJA, R_E_C_N_O_, D_E_L_E_T_

If ZX5->(DbSeek(xFilial("ZX5")+SE1->(E1_CLIENTE+E1_LOJA),.F.))
    l_Ret := .T.
ElseIf ZX5->(DbSeek(xFilial("ZX5")+SE1->E1_CLIENTE,.F.))
    l_Ret := .T.
EndIf

Return l_Ret

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    | fEstMT    ³ Autor ³ Lucas Amélio (Focus)  ³ Data ³ 12/02/20 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Envia email com NF faturada para o estado MT                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nenhum.                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nil.                                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Analista Resp.³  Data  ³ Manutencao Efetuada                            ³±±
±±³ÄÄÄÄÄÄÄÄÄÄÄÄÄÄ³ÄÄÄÄÄÄÄÄ³ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³              ³  /  /  ³                                                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function fEstMT()

Local c_Assunto	:= "Mensageiro Protheus - Nota Faturada "+SF2->F2_DOC+"/"+SF2->F2_SERIE+" - Estado MT"
Local c_HTML	:= ""

c_HTML += '<HTML><!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">'
c_HTML += '	<html xmlns="http://www.w3.org/1999/xhtml">'
c_HTML += '	<style type="text/css">'
c_HTML += '		.formulario { FONT-SIZE: 10px; COLOR: #000000; FONT-FAMILY: Verdana, Arial, Helvetica, sans-serif; TEXT-DECORATION: none; font-weight: bold; }'
c_HTML += '		.formulario2{ FONT-SIZE: 11px; COLOR: #333333; FONT-FAMILY: Verdana, Arial, Helvetica, sans-serif; TEXT-DECORATION: none; }'
c_HTML += '		.formularioTit { FONT-SIZE: 13px; COLOR: #FFFFFF; FONT-FAMILY: Verdana, Arial, Helvetica, sans-serif; TEXT-DECORATION: none; font-weight: bold; }'
c_HTML += '		.formularioTit2 { FONT-SIZE: 13px; COLOR: #000000; FONT-FAMILY: Verdana, Arial, Helvetica, sans-serif; TEXT-DECORATION: none; font-weight: bold; }'
c_HTML += '	</style>'
c_HTML += '<head>'
c_HTML += '	<title>Aviso de pedido a ser liberado</title>'
c_HTML += '</head>'

c_HTML += '<table width="95%" border="0" align="center">'
c_HTML += '<tr>'
c_HTML += '	<td colspan="8" >'
c_HTML += '		<img src="'+GetMV("MV_XLOGO")+'" border="0">'
c_HTML += '	</td>'
c_HTML += '<tr>'

c_HTML += '<tr>'
c_HTML += '	<td colspan="8" bgcolor="#0597CD">'
c_HTML += '		<div align="center"><span class="formularioTit"><h2>Aviso Eletrônico<h2></span></div>'
c_HTML += '	</td>'
c_HTML += '</tr>'
c_HTML += '<tr>'
c_HTML += '	<td colspan="8">&nbsp;</td>'
c_HTML += '</tr>'
c_HTML += '<tr>'
c_HTML += '	<td colspan="12"><span class="formularioTit2">Abaixo segue algumas informações da Nota Faturada para o Mato Grosso</span></td>'
c_HTML += '</tr>'
c_HTML += '<tr>'
c_HTML += '	<td colspan="8">&nbsp;</td>'
c_HTML += '</tr>'
c_HTML += '<tr>'
c_HTML += '	<td colspan="8" bgcolor="#0597CD"><div align="center"><span class="formulario"><h5> Inforamações da Nota Faturada<h5></span></div></td>'
c_HTML += '</tr>'
c_HTML += '<tr>'
c_HTML += '	<td colspan="8">&nbsp;</td>'
c_HTML += '</tr>'

c_HTML += '<tr>'
c_HTML += '	<td bgcolor="#ECF0EE" class="formulario">Filial</td>'
c_HTML += '	<td bgcolor="#ECF0EE" class="formulario">Nota</td>'
c_HTML += '	<td bgcolor="#ECF0EE" class="formulario">Série</td>'
c_HTML += '	<td bgcolor="#ECF0EE" class="formulario">Cliente</td>'
c_HTML += '	<td bgcolor="#ECF0EE" class="formulario">Loja</td>'
c_HTML += '	<td bgcolor="#ECF0EE" class="formulario">Estado</td>'
c_HTML += '	<td bgcolor="#ECF0EE" class="formulario">Município</td>'
c_HTML += '	<td bgcolor="#ECF0EE" class="formulario">Guia de Embarque</td>'
c_HTML += '</tr>'

c_HTML += '<tr>'
c_HTML += '	<td  bgcolor="#F7F9F8" class="formulario2">'+SF2->F2_FILIAL+'</td>'
c_HTML += '	<td  bgcolor="#F7F9F8" class="formulario2">'+SF2->F2_DOC+'</td>'
c_HTML += '	<td  bgcolor="#F7F9F8" class="formulario2">'+SF2->F2_SERIE+'</td>'
c_HTML += '	<td  bgcolor="#F7F9F8" class="formulario2">'+SF2->F2_CLIENTE+'</td>'
c_HTML += '	<td  bgcolor="#F7F9F8" class="formulario2">'+SF2->F2_LOJA+'</td>'
c_HTML += '	<td  bgcolor="#F7F9F8" class="formulario2">'+SF2->F2_EST+'</td>'
c_HTML += '	<td  bgcolor="#F7F9F8" class="formulario2">'+SA1->A1_MUN+'</td>'
c_HTML += '	<td  bgcolor="#F7F9F8" class="formulario2">'+SF2->F2_XGSAIDA+'</td>'
c_HTML += '</tr>'

c_HTML += '<tr>'
c_HTML += '	<td class="formulario"><p>&nbsp;</p></td>'
c_HTML += '</tr>'

c_HTML += '<tr>'
c_HTML += '	<td colspan="8" bgcolor="#0597CD"><div align="center"><span class="formulario"><h5>Informática Gomes da Costa</h5></span></div></td>'
c_HTML += '</tr>'

c_HTML += '<tr>'
c_HTML += '	<td colspan="8" bgcolor="#0597CD"><div align="center"><span class="formulario"><h5>Ajudando você no seu dia-a-dia!</h5></span></div></td>'
c_HTML += '</tr>'

c_HTML += '</table>'
c_HTML += '</body>'
c_HTML += '</html>'

U_GDCSendMail("","",GetMV("MV_RELSERV"),"0185",c_Assunto,c_HTML,"","","")

Return Nil