#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ MBRWBTN  ³ Autor ³ Douglas Viegas Franca ³ Data ³ 21/02/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Ponto de Entrada acionado ao clicar em qualquer botao de um³±±
±±³          ³ browse.                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nil => Nenhum                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ l_Ret => Se .T. prossegue com a funcionalidade selecionada.³±±
±±³          ³          Se .F. aborta a operacao.                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Analista Resp.³  Data  ³ Manutencao Efetuada                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Tiago D. Cruz ³04/03/08³Tela para Selecao de Cliente/Fornecedor        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Douglas Franca³05/12/08³Criacao da funcao fAjtLib que ira verificar e  ³±±
±±³              ³        ³se necessario ajustar o campo C6_QTDEMP        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Douglas Franca³30/12/08³Removido o filtro para a serie 4 (motivo NF-e) ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Douglas Franca³05/01/09³Inserido o filtro para a serie 3 no lugar da 4.³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Claudio Dias  ³25/03/09³Fazendo adaptacao para consistir e emitir um   ³±±
±±³              ³        ³aviso caso o cliente esteja bloqueado nos se-  ³±±
±±³              ³        ³guintes pontos do sistema.                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Claudio Dias  ³27/05/09³Criando variaveis para utilizacao no M460RAT,  ³±±
±±³              ³        ³referente ao chamado 3183.                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Tiago D. Cruz ³05/08/09³Tratamento feito para o item retornar da rotina³±±
±±³              ³        ³de docto entrada - chamado 4274.               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Tiago D. Cruz ³06/08/09³Tratamento feito para problema na pre nota de  ³±±
±±³              ³        ³entrada devido a tratamento feito no ID 4274   ³±±
±±³              ³        ³chamado ID 4550.                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Tiago D. Cruz ³13/08/09³Foi necessario criar a variavel C_EST para que ³±±
±±³              ³        ³no retorno de NFS de venda nao de problema no  ³±±
±±³              ³        ³Inicializador do campo F1_EST. Este tratamento ³±±
±±³              ³        ³foi feito para a pre nota carregar a Uf do for ³±±
±±³              ³        ³necedor - chamdo ID 46669.                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Tiago D. Cruz ³13/08/09³Refazer o tratamento feito para que o usuario  ³±±
±±³              ³        ³possa utilizar o item Retornar do docto. 	  ³±±
±±³              ³        ³entrada Chamado ID - 4681 					  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Tiago D. Cruz ³10/12/10³Implementar tratamento p/ centro de custo bloqu³±±
±±³              ³        ³eado quando prepara documento via botao no pedi|±±
±±³              ³        ³do de venda ID - 10478		                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Tiago D. Cruz ³12/01/11³10693:Tratamento de peso.                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Douglas Franca³23/03/11³Ch. 11.855 => Consistir se a qtde liberada esta³±±
±±³              ³        ³igual a quantidade no pedido de vendas.        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Felipe A. Reis³08/03/12³CH 9461 - Pedido de bonificacao x Venda        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Felipe Aguiar ³09/04/12³ ID: 16914 - gravar a chave(F2_CHVNFE)da nota  ³±±
±±³			 	 ³		  ³de saida na nota de entrada para transferencias³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Felipe A. Reis³18/04/12³CH 17200 - Tratamento exclusao bonificacao     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Felipe A. Reis³29/01/13³CH 26138 - Inclusao da chave completa no DCF.  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Douglas Franca³29/01/13³PRJ: Desmembramento Automatico de Pedidos      ³±±
±±³              ³        ³Efetuar a chamada do faturamento atraves da no-³±±
±±³              ³        ³va tela de liberacao / faturamento de pedidos. ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Flavio V.     ³03/07/15³Projeto WMS: Tratamento para faturar Pedidos   ³±±
±±³              ³        ³apenas quando estes estiverem com status       ³±±
±±³              ³        ³lib. para logistica.                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Felipe Reis   ³24/11/15³ Ajustes para Integragracao do WMS.            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Claudio Dias  ³03/12/15³Chamado : 58452 - Adicionando validações para  ³±±
±±³              ³        ³classificação da Pré-Nota gerada pelo Ret.Simb.³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Michael Castro³11/02/16³Chamado : 60206 - Adicionando exceções de Vali-³±±
±±³              ³        ³dações na classificação da Pré-Nota gerada pelo³±± 
±±³              ³        ³Ret.Simb. e criação de um novo parametro.      ³±±
±±³              ³        ³ MV_XROTCLA --> Origem de Rotina Exceção       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Felipe Reis   ³12/01/16³ 3a Fase do projeto de Rastreabilidade.    	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Michael Castro³27/10/16³ Ajuste na rotina IncDocEnt() inclusão de um   ³±±
±±³              ³GetArea e RestArea. Chamado: 64608                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Felipe Reis   ³04/04/17³ Validacao faturamento de baixa de estoque.	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Michael Castro³08/05/17³ Busca Chave NF saida e Grava na Classificação ³±±
±±³              ³        ³ Chamado: 58306 - Wanderson                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³E.H.Cozaciuc  ³19/05/17³ Sem verificação de baixa de estoque para nf do³±±
±±³              ³        ³ tipo N e B, conforme chamado: 69260           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Felipe A. Reis³19/05/17³ Ch.69281 - Mensagem para informar usuario que ³±±
±±³              ³        ³ o pedido contem sardinha e atum para filial 07³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Felipe Aguiar ³24/05/17³Chamado 69375 - Nao solicitar o vinculo de     ³±±
±±³              ³        ³solicitacao de baixa para o almox 82.          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Michael Castro³06/06/17³Chamado 69559 - Ajuste na classificação para   ³±±
±±³              ³        ³NF sem guiar  não vincular no WMS              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Felipe Aguiar ³11/10/17³Chamado 72111 - Ajuste botao MATA430.          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Daniel Ciriano³21/03/18³Chamado #75301 - Ajuste decorrente do #74054.  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³E.H.Cozaciuc  ³18/09/18³Chamado 81377 - Validacao NCM bloqueado.       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³E.H.Cozaciuc  ³19/12/18³Chamado 83264 - Verifica Pais do SA1, se for EX³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Felipe Reis   ³04/07/19³Chamado 88709 - Duplicacao tela de entrada     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function MBRWBTN()

Local a_AreaATU := GetArea()
Local l_Ret 	:= .T.
Local oCbo
Local c_Query	:= ""

Private c_Funcao := Upper(AllTrim(FunName()))
Private n_Botao	 := PARAMIXB[3]
Private c_NomOpc := PARAMIXB[4]

//CH 74524 - LOG
Private a_VarsLog	:= {MsDate(), Time(), "Botao: " + AllTrim(Str(n_Botao)) + "  - Opcao: " + c_NomOpc} //[1]-Data; [2]-Hora; [3]-Observacao

Public l_Classif := .T.  //	ID 16914: Felipe Aguiar - Variavel usada no PE MT103FIM                              
Public l_BlqPCF  := .F.  	//	Projeto PCF: Felipe Reis - Variavel usada no PE MT100TOK                              
Public n_OpTes   := 0   	//	ID 22440: Felipe Aguiar - Variavel usada no PE MT080GRV
Public n_RetCount := 0 // ID 15466 - Variavel utilizada para o Sispag Itau - Felipe Aguiar                                   

//- ID [3183] - Claudio Dias Junior ---------------------------------------------------------------------
// Variaveis utilizadas no P.E. M460RAT.PRW
Public n_TotFrete	:= 0
Public n_TotSeguro	:= 0
Public n_TotDespesa	:= 0
//-------------------------------------------------------------------------------------------------------

Public l_EhXml := .F. // ID 52098 - Variavel utilizada no PE MT140TOK

//Mostra o codigo da rotina
fValida()

If c_Funcao == "MATA410" //Pedido de Venda
	
	Public l_EhDesmemb := .F.
	If AllTrim(c_NomOpc) == "MA410PVNFS"  //Prep.doc.Saida

		c_BkpFilial	:= cFilAnt
		cFilAnt		:= SC5->C5_FILIAL
		a_AreaATU	:= GetArea()
		a_AreaSM0	:= SM0->(GetArea())
		DbSelectArea("SM0")
		DbSetOrder(1)
		DbSeek(cEmpAnt+SC5->C5_FILIAL, .F.)

		l_Ret := U_GDCPREPDOC(.T., {})

		cFilAnt := c_BkpFilial
		RestArea(a_AreaSM0)
		RestArea(a_AreaATU)
		
	ElseIf AllTrim(c_NomOpc) == "U_GDCDPV01"  //Desmenbrar
		
		l_EhDesmemb := .T.
		//Verifica se o cliente do PV esta bloqueado
		If !fVldCliente()
			l_Ret := .F.
			
			//Verifica se o(s) centro(s) de custo do PV esta(o) bloqueado(s)
		ElseIf !fVlCCusto(SC5->(C5_FILIAL+C5_NUM))
			l_Ret := .F.
		Endif
		
		//Verifica se existem pedidos de bonificacao vinculado
		If !u_fExcBon(SC5->C5_FILIAL,SC5->C5_NUM)
			l_Ret := .F.
		EndIf
		
	ElseIf AllTrim(c_NomOpc) == "A410ALTERA" //Alteracao
		
		If ( AllTrim(SC5->C5_XFLAGST) == "40" .And. SC5->C5_XTEVELL == "1" )
			MsgStop("Este Pedido não pode ser alterado, deve ser devolvido pela logística.","INCONSISTÊNCIA")
			l_Ret := .F.
		EndIf
		
		If (l_Ret)
			If !Empty(SC5->C5_XGSAIDA)   
				MsgStop("Este Pedido não pode alterado, pois está vinculado a uma Guia de Embarque. Favor entrar em contato com a Logística","INCONSISTÊNCIA")
				l_Ret := .F.
			EndIf
		EndIf
	
	ElseIf AllTrim(c_NomOpc) == "A410DELETA" //Excluir
		
		If AllTrim(SC5->C5_XORIGEM) == "PCF"
			MsgStop("O pedido não pode ser excluído, pois foi gerado pelo PC Factory.","I N C O N S I S T Ê N C I A")
			l_Ret := .F.
		EndIf
		
		If l_Ret
			l_Ret := fEstPVTRF()
		EndIf
		
	Endif
	
ElseIf c_Funcao == "MATA440"  //Liberacao de Pedidos
	
	If AllTrim(c_NomOpc) == "A440AUTOMA" //Automatico
		
		MsgRun("Verificando liberações. Por Favor, aguarde...", "", {|| fAjtLib() })
		
		a_AreaSX1 := SX1->(GetArea())
		
		SX1->(DbSetOrder(1))
		SX1->(DbSeek("MTALIB    09"))
		SX1->(RecLock("SX1", .F.))
		SX1->X1_PRESEL := 2
		SX1->(MsUnLock())
		
		RestArea(a_AreaSX1)
		
	Endif
	
ElseIf c_Funcao == "MATA240"  //Movimento Interno
	
	If AllTrim(c_NomOpc) == "A240ESTORN" //Estorno
		
		///////////////////////////////////////////
		// Verifica se pode movimentar o estoque //
		///////////////////////////////////////////
		If !U_GVLDME(,SD3->D3_EMISSAO)
			l_Ret := .F.
		ElseIf !U_GDVLDMI(cUserName, cEmpAnt+SD3->D3_FILIAL, SD3->D3_LOCAL, SD3->D3_GRUPO, "1", SD3->D3_COD)
			l_Ret := .F.
			MsgStop("Usuário sem permissão para efetivar o estorno. Favor contatar o depto. de Planejamento e Custos através do ramal 2680.", "Acesso negado (ZZA)")
		EndIf
		
	EndIf
	
ElseIf c_Funcao == "MATA261"  //Transferencia Interna Modelo II
	
	If AllTrim(c_NomOpc) == "A261ESTORN" //Estorno
		
		Public l_EstTrf := .T.
		
	Endif

ElseIf c_Funcao == "MATA110"  //Solicitação de Compra

	If cEmpAnt == "04" 
		Aviso("ATENCAO","Rotina descontinuada, favor incluir a solicitação de compra na empresa 03.")
		l_Ret := .F.
	EndIf
	
ElseIf c_Funcao == "MATA103" .Or. c_Funcao == "GDCMT103"  //Nota Fiscal de Entrada
	
	//Public N_OPC	  := n_Botao // Adiconado para tratar o caso do retornar no docto entrada sem ocorrer problemas na Pre Nota.?	
	Public c_LocDevCD := ""
	
	If n_Botao == 3 .And. AllTrim(c_NomOpc) == "A103NFISCAL" .And. c_Funcao == "MATA103" //Nota Fiscal de entrada (Incluir)
		
		If Type("l_UNQNF") == "U" .Or. !l_UNQNF////Provisorio para nao aparecer a tela de CNPJ 2x - Ch.89041
			l_Ret := IncDocEnt(c_Funcao)
			l_UNQNF := .T.
		EndIf
		l_BlqPCF := .T.
		//Public N_OPC	  := 3
		
	Elseif n_Botao == 3 .And. AllTrim(c_NomOpc) == "A103DEVOL" //Nota Fiscal de entrada (Retornar)
		
		Public C_EST := Space(02)//Esta variavel tem que ser criada por que esta como Inicializador do campo F1_EST
		Public C_TIPO_F1 := Space(01)
		Public C_FORN_F1 := Space(06)
		Public C_LOJA_F1 := Space(02)
		//Public N_OPC	  := 5
		
	Elseif n_Botao == 4 //Classificacao da NF	
			 
		If ( SF1->F1_FILIAL == "11" .And. SF1->F1_FORNECE = "999999" .And. GetMV("MV_XNFWMS") )	
	
		//- Busca os dados de que serao utilizados na pre-nota de entrada, na filial de destino da transferência
			a_DadosOri := U_fGetInfCli(SF1->F1_FILIAL, SF1->F1_TIPO, SF1->F1_LOJA)
		
			DbSelectArea("SF2")
			DbSetOrder(1) // F2_FILIAL, F2_DOC, F2_SERIE, F2_CLIENTE, F2_LOJA, F2_FORMUL, F2_TIPO, R_E_C_N_O_, D_E_L_E_T_
			DbGoTop()
			If DbSeek(a_DadosOri[4]+SF1->(F1_DOC+F1_SERIE+a_DadosOri[1]+a_DadosOri[2]), .F.)
				If !Empty(SF2->F2_XGSAIDA) // Realiza Integração com WMS

					//Posiciona no primeiro item da nota
					DbSelectArea("SD1")
					SD1->(DbSetOrder(1))//D1_FILIAL, D1_DOC, D1_SERIE, D1_FORNECE, D1_LOJA, D1_COD, D1_ITEM, R_E_C_N_O_, D_E_L_E_T_
					SD1->(DbGoTop())
					SD1->(DbSeek(SF1->(F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA)))
			
					//Somente Produtos que são controlados pelo WMS		
					While ( SD1->(!Eof()) .And. SF1->(F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA) == SD1->(D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA) )
						If ( SD1->D1_LOCAL $ "F2#F5#" .And. GetAdvFVal("SB1","B1_XWMS",xFilial("SB1")+SD1->D1_COD,1,"") == "1" )	 		
							Processa({|| l_Ret := u_fNFEWMS(1) },"Buscando Informações no WMS... Por Favor Aguarde.") //Validacao
							Exit
						EndIf
						SD1->(DbSkip())
					EndDo	
				EndIf				
			EndIf	
		EndIf
		
		If l_Ret
		
			//Valida de a Nota Fiscal é de retonro simbólico, caso seja é obrigado a faer pela rotina "Clas.Ret.Simb."
			If SF1->F1_FILIAL $ "05#20#" .And. SF1->F1_FORNECE = "999999"
			
				//- Busca os dados de que serao utilizados na pre-nota de entrada, na filial de destino da transferência
				a_DadosOri := U_fGetInfCli(SF1->F1_FILIAL, SF1->F1_TIPO, SF1->F1_LOJA)
			
				DbSelectArea("SF2")
				DbSetOrder(1) // F2_FILIAL, F2_DOC, F2_SERIE, F2_CLIENTE, F2_LOJA, F2_FORMUL, F2_TIPO, R_E_C_N_O_, D_E_L_E_T_
				DbGoTop()
				If DbSeek(a_DadosOri[4]+SF1->(F1_DOC+F1_SERIE+a_DadosOri[1]+a_DadosOri[2]), .F.) 
				
 				   //*********************************
 				   //*Michael Castro / Chamado:60206 *
 				   //************************************************************************************************************************
 				   //*Validação de Retorno Simbolico validava qualquer Pedido mesmo feito manualmente                                       *
 				   //*Criei a variavel c_RotOriC5 pra diferenciar quando vem de alguma rotina customizada                                   *
 				   //*Foi criado também um parametro (MV_XROTCLA) para colocar as rotinas que não devem validar retorno simbolico           *
 				   //************************************************************************************************************************
 				   c_RotOriC5 := ""
				   c_RotOriC5 := AllTrim( GetAdvFVal("SC5","C5_XORIGEM",SF2->F2_FILIAL+SF2->F2_PEDIDO+SF2->F2_CLIENTE+SF2->F2_LOJA,1,"")	)
				   
					If !Empty(SF2->F2_XNFRSIM) .And. AllTrim(SF2->F2_XNFRSIM) <> "X" .And. !c_RotOriC5 $ AllTrim(GetMv("MV_XROTCLA"))
						Aviso("><((((º> - A V I S O ! ","Essa Pré-Nota foi originada pela rotina 'Gera Ret.Simb.'. A classificação da mesma deverá "+;
						"ser feita pela rotina 'Clas.Ret.Simb', dentro de ações relacionadas.",{"OK"})
						l_Ret := .F. 
					EndIf
				EndIf	
			EndIf
		EndIf	
		
		If SF1->F1_XEXPPCF == "1"
			MsgStop("Esta nota ainda não foi descarregada ou a quantidade descarregada não confere com a pré nota.","Integração PC-Factory")
			l_Ret := .F.
		EndIf
		
		If AllTrim(SF1->F1_XAPVPRE) == "*"
			MsgStop("Esta Pré nota ainda não foi aprovada pelo setor responsável.","ATENCAO")
			l_Ret := .F.
		EndIf		

		If l_Ret .And. SF1->F1_FORNECE = "999999"
			GrvCNfe() //Chama Rotina para realizar a gravação da Chave NF da nota de Saída
		EndIf		
		
	ElseIf n_Botao == 5 //Exclusao de documento de entrada
	
		If !Empty(SF1->F1_XREGVEI)
			MsgStop("Esta nota está vinculada ao registro de veículo " + SF1->F1_XREGVEI + "." ,"ATENCAO")
			l_Ret = .F.
		EndIf
		
		l_Classif := .F.	
			
	ElseIf  AllTrim(STR(n_Botao)) <> "4" // Felipe Aguiar  - Chamado 16914
		
		l_Classif := .F.
		
	Endif
	
ElseIf c_Funcao == "MATA140"  //Pre-Nota Fiscal de Entrada
	
	//Public N_OPC	  := 3 // Adiconado para tratar o caso do retornar no docto entrada sem ocorrer problemas na Pre Nota.?
	
	l_Classif := .F. // Felipe Aguiar  - Chamado 16914
	
	If n_Botao == 3 //Nota Fiscal de entrada (Incluir)
		If Type("l_UNQPreNF") == "U" .Or. !l_UNQPreNF////Provisorio para nao aparecer a tela de CNPJ 2x - Ch.88709
			l_Ret := IncDocEnt(c_Funcao)
			l_UNQPreNF := .T.
		EndIf
	Endif
	
	//QS tratamento para 3 fase do projeto ACD
	//Botao alterar para verificar primeiro se foi ja executado no conferencia
	If n_Botao == 4 // Botao alterar //.AND. cFilAnt == '04'  //ElseIf FunName() == 'MATA140' .AND.
		
		DbSelectArea("DCF")
		DbSetOrder(2) //DCF_FILIAL+DCF_SERVIC+DCF_DOCTO+DCF_SERIE+DCF_CLIFOR+DCF_LOJA+DCF_CODPRO
		//Botao alterar da pre nota com servico 003
		If DbSeek(xFilial("DCF")+"003"+SF1->(F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA))//Verifica a conferencia cega em que processo se encontra
			
			If DCF->DCF_STSERV <> '1' // entra se o servico de wms ja tiver executado ou com problema ou seja 2 e 3
				MsgStop("Necessario estornar o servico de Conferencia cega antes de alterar a pre nota !")
				l_Ret:= .F.
			EndIf
		EndIf
	EndIf
	
	If AllTrim(c_NomOpc) == "A140ESTCLA"     //ESTORNA CLASSIFICACAO
		
		IF (SF1->F1_DTDIGIT <> DDATABASE) .AND. ALLTRIM(SF1->F1_STATUS) <> ''
			MsgStop("Esta nota foi digitada em "+DTOC(SF1->F1_DTDIGIT)+". Só é permitido estornar a classificação desta nota no mesmo dia do lançamento. Qualquer dúvida consulte o Depto Fiscal.","MBRWBTN")
			l_Ret:= .F.
		ENDIF 
		
		//*************  Cintia Araujo - 08/2015 - Inicio -
		If l_Ret == .T. .And. !Empty(SD1->D1_XPEDP3)
			MsgStop("Essa Nota foi  gerado pelo retorno da Filial 11, será necessária a exclusão da NF de origem", "Inconsistência")  
			l_Ret := .F.
		EndIf
		//*************  Cintia Araujo - 08/2015 - Fim -

		//Verifica se existe dado para integrar do Compila para o SE Suite
		If l_Ret
			DbSelectArea("Z10")
			Z10->(DbSetOrder(1))//Z10_FILIAL, Z10_CHVNFE, Z10_TIPARQ, R_E_C_N_O_, D_E_L_E_T_
			If Z10->(DbSeek(xFilial("Z10")+SF1->F1_CHVNFE))
				If Empty(Z10->Z10_DTSE) .And. !Empty(Z10->Z10_IDSE)
					l_Ret := .F.
					MsgStop("Favor aguardar a integração da classificação da nota no SE Suite para realizar a exclusão.","ATENCAO") 
				EndIf
			EndIf
		EndIf

	EndIf
	
	If n_Botao == 4 .Or. ( n_Botao == 5 .And. AllTrim(c_NomOpc) == "A140NFISCAL" )     //ALTERAÇÃO/EXCLUSÃO
		
		If !Empty(SF1->F1_XREGVEI) .And. n_Botao == 5 
			MsgStop("Esta nota está vinculada ao registro de veículo " + SF1->F1_XREGVEI + "." ,"ATENCAO")
			l_Ret = .F.
		EndIf
		
		//Valida de a Nota Fiscal é de retonro simbólico, caso seja é obrigado a faer pela rotina "Clas.Ret.Simb."
		If l_Ret .And. SF1->F1_FILIAL $ "05#20#" .And. SF1->F1_FORNECE = "999999"
			//- Busca os dados de que serao utilizados na pre-nota de entrada, na filial de destino da transferência
			a_DadosOri := U_fGetInfCli(SF1->F1_FILIAL, SF1->F1_TIPO, SF1->F1_LOJA)
		
			DbSelectArea("SF2")
			DbSetOrder(1) // F2_FILIAL, F2_DOC, F2_SERIE, F2_CLIENTE, F2_LOJA, F2_FORMUL, F2_TIPO, R_E_C_N_O_, D_E_L_E_T_
			DbGoTop()
			If DbSeek(a_DadosOri[4]+SF1->(F1_DOC+F1_SERIE+a_DadosOri[1]+a_DadosOri[2]), .F.)
				If !Empty(SF2->F2_XNFRSIM) .And. AllTrim(SF2->F2_XNFRSIM) <> "X"
					Aviso("><((((º> - A V I S O !","Essa Pré-Nota foi originada pela rotina 'Gera Ret.Simb.'. " +Chr(10)+Chr(10)+;
					      "Devido a isso Não é possível alterar/excluir, será necessário efetuar o estorno da NF de origem",{"OK"})
					l_Ret := .F.
				EndIf
			EndIf	
		EndIf	
		
	EndIf
	// Entrada NFE - XML - Variavel utilizada no PE MT140TOK
	If n_Botao == 10
		l_EhXml := .T.
	EndIF
	
ElseIf c_Funcao == "OMSA010"  //Tabela de Preco
	
	Public l_CopyTP := (n_Botao == 6)
	
	If AllTrim(c_NomOpc) == "OMS010ALT" .Or. AllTrim(c_NomOpc) == "VIEWDEF.OMSA010" //Alteracao ou Exclusao
		
		If DA0->DA0_ATIVO == "2" //Ativo igual a nao
			
			l_Ret := .F.
			MsgStop("Não é possível alterar ou excluir uma tabela de preço inativa.", "Inconsistência")
			
		Endif
		
	Endif
	
	//Abaixo tratamento Emerson QS para somente mensagem na tentaiva de altear ou excluir etiqueta ja apontada 1 fase
ElseIf 	FunName() == 'MBRONZAA' .AND. ALLTRIM(STR(n_Botao)) $ ("4|5")//alterar ou exluir
	
	If ZAA->ZAA_PRODUC $ ("S|A|T") // Ja Produzida, nao pode nem alterar nem exluir antes tem que estornar op
		MsgStop("Ordem de producao ja Apontada, nao será possivel nem alterar ou exluir !")
		l_Ret	:= .F.
	EndIf
	
	//Abaixo tratamento Emerson QS para a tela da ordem de separacao 2 fase
ElseIf FunName() == 'MBRONZBB' .AND. ALLTRIM(STR(n_Botao)) $ ("4|5")// exluir
	
	If !empty(ZBB->ZBB_STATUS)  // Verifica se o status esta como pedido em aberto ou faturado para nao deixar usuario alterar ou excluir.
		MsgStop("Esta Ordem de Separacao: "+Alltrim(ZBB->ZBB_ORDSEP)+" possui pedido em aberto ou ja foi faturado !")
		l_Ret	:= .F.
	EndIf
	
ElseIf c_Funcao == "MATA080" // Cadastro de TES
	
	If 	n_Botao == 4  // Somente alteracao - ID 22440
		n_OpTes := n_Botao
	EndIf
	
ElseIf c_Funcao == "MATA250" //Producao
	
	If AllTrim(c_NomOpc) == "A250ESTORN" //Estorno - Ch. 23432
		
		dbSelectArea("ZAA")
		ZAA->(dbgotop())
		ZAA->(dbsetorder(5))//ZAA_FILIAL, ZAA_DOCPRO, ZAA_NUMPAL, ZAA_PRODUT, R_E_C_N_O_, D_E_L_E_T_
		If ZAA->(dbseek(xFilial("ZAA")+SD3->D3_DOC))
			
			dbSelectArea("ZBB")
			ZBB->(dbgotop())
			ZBB->(dbsetorder(2))//ZBB_FILIAL, ZBB_PRODUT, ZBB_NUMPAL, ZBB_LOTE, R_E_C_N_O_, D_E_L_E_T_
			ZBB->(dbseek(ZAA->(ZAA_FILIAL + ZAA_PRODUT + ZAA_NUMPAL + ZAA_LOTEIN)))
			
			While ZBB->(!Eof()) .And. ZBB->(ZBB_FILIAL + ZBB_PRODUT + ZBB_NUMPAL + ZBB_LOTE) == ZAA->(ZAA_FILIAL + ZAA_PRODUT + ZAA_NUMPAL + ZAA_LOTEIN)
				
				If !Empty(ZBB->ZBB_NOTA)
					MsgStop("Não será possível realizar o estorno, pois essa produção faz referência ao palete [ "+ZBB->ZBB_NUMPAL+" ] e nota fiscal [ "+ZBB->ZBB_NOTA+" ]", "I N C O S I S T Ê N C I A")
					l_Ret := .F.
				EndIf
				
				ZAA->(dbSkip())
			EndDo
			
		EndIf
		
	EndIf
	
ElseIf c_Funcao == "MATA650" //Ordem de Producao
	
	If AllTrim(c_NomOpc) == "A650DELETA" //Alteracao
		
		If SC2->C2_XDRM == "1"
			MsgStop("Não será possível alterar OP prevista gerada pelo Drummer.","A T E N Ç Ã O ")
			l_Ret	:= .F.
		EndIf
	EndIf
	
ElseIf c_Funcao == "MATA121" //Pre-Nota
	
	If n_Botao == 4 //Alteracao
		
		DbSelectArea("SD1")
		DbSetOrder(27)//D1_FILIAL, D1_PEDIDO, D1_ITEMPC, R_E_C_N_O_, D_E_L_E_T_
		If DbSeek(xFilial("SC7")+SC7->C7_NUM+SC7->C7_ITEM)
			MsgStop("Pedido de compra não pode ser alterado pois está vinculado a nota fiscal " + SD1->D1_DOC + ", serie " + SD1->D1_SERIE + ".","A T E N Ç Ã O ")
			l_Ret := .F.
		EndIf
		
	EndIf
	
	If n_Botao == 5 //Exclusao
		
		If AllTrim(SC7->C7_XORIGEM) == "PCF"
			MsgStop("Pedido de compra não pode ser excluido pois foi gerado pelo PC Factory.","A T E N Ç Ã O ")
			l_Ret := .F.
		EndIf
		
	EndIf
	
ElseIf c_Funcao == "FINA070" //Baixa de Titulos a Receber
	
	If AllTrim(c_NomOpc) == "FA070CAN" //Cancelamento
		
		If SE1->E1_TIPO = "NCC"
			
			c_Query := " SELECT E5_DATA, R_E_C_N_O_ AS NUMREC FROM SE5030		 " 	+ Chr(13) + Chr(10)
			c_Query += " WHERE R_E_C_N_O_ = (            " 	+ Chr(13) + Chr(10)
			c_Query += "	SELECT MAX(R_E_C_N_O_) FROM (" 	+ Chr(13) + Chr(10)
			c_Query += "		SELECT * FROM SE5030     " 	+ Chr(13) + Chr(10)
			c_Query += "		WHERE D_E_L_E_T_ = ''"  	+ Chr(13) + Chr(10)
			c_Query += "		AND E5_PREFIXO 	= '"		+ SE1->E1_PREFIXO 	+"'" + Chr(13) + Chr(10)
			c_Query += "		AND E5_NUMERO 	= '"		+ SE1->E1_NUM     	+"'" + Chr(13) + Chr(10)
			c_Query += "		AND E5_PARCELA 	= '"		+ SE1->E1_PARCELA 	+"'" + Chr(13) + Chr(10)
			c_Query += "		AND E5_TIPO 	= '"		+ SE1->E1_TIPO    	+"'" + Chr(13) + Chr(10)
			c_Query += "		AND E5_CLIFOR 	= '"		+ SE1->E1_CLIENTE 	+"'" + Chr(13) + Chr(10)
			c_Query += "		AND E5_LOJA 	= '"		+ SE1->E1_LOJA 		+"')"+ Chr(13) + Chr(10)
			c_Query += "	AS TABELA             " 		+ Chr(13) + Chr(10)
			c_Query += " )                        " 		+ Chr(13) + Chr(10)
			
			MemoWrite("CanBaixDtTit.Sql", c_Query)
			
			If Select("TRB") > 0
				TRB->(DbCloseArea())
			Endif
			
			TcQuery c_Query New Alias "TRB"
			
			//Atualiza campo de lote para que não gere outro registro e apareca no extrato bancario ch. 41871
			SE5->( dbgoto( TRB->NUMREC ) )
			RecLock("SE5",.F.)
			SE5->E5_LOTE := ""
			SE5->(MsUnLock())
			
		EndIf
	Endif
	
	//*************  Cintia Araujo - 08/2015 - Inicio -
ElseIf c_Funcao == "MATA430"
	
	If AllTrim(c_NomOpc) == "U_RFATA004" .AND. n_Botao == 4 //Alteração
		
		cNum      := SC0->C0_NUM
		cTipRese  := SuperGetMV("MV_XTRPRES",,"01.02")
		nTipRese  := 0                                                                                 
		aAreaSC0  := SC0->(GetArea())
		
		SC0->(DbEval( { || nTipRese += If( SC0->C0_XTPPOD3 $ cTipRese, 1, 0) },{ || .T. },{ || SC0->C0_NUM == cNum .And. SC0->(!Eof()) } ))
		
		If nTipRese > 0
			MsgInfo("Reserva com tipo que não poderá sofrer manutenção, verifique !","")
			l_Ret := .F.
		EndIf
		
		RestArea(aAreaSC0)
	EndIf
	//*************  Cintia Araujo - 08/2015 - Fim
	
ElseIf c_Funcao == "COMXCOL"
	
	Public c_ChvXPROC := ""
	
ElseIf c_Funcao == "MATA030"
	
	Public c_PubTpPg := SA1->A1_TPCOBR
	
EndIf

//CH 74524 - LOG
U_GrvLogFunc("MBRWBTN", a_VarsLog)

RestArea(a_AreaATU)

Return l_Ret
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ fVldPV   ³ Autor ³ Douglas Viegas Franca ³ Data ³ 21/02/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Funcao que ira verificar se existe estoque fisico para que ³±±
±±³          ³ seja possivel faturar o pedido de venda.                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nil => Nenhum                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ l_Ret => Se .T. pode faturar.                              ³±±
±±³          ³          Se .F. nao pode faturar, pois falta estoque.      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Analista Resp.³  Data  ³ Manutencao Efetuada                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³              ³  /  /  ³                                               ³±±
±±³              ³  /  /  ³                                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function fVldPV()

Local a_AreaATU		:= GetArea()
Local a_AreaSC6		:= SC6->(GetArea())
Local c_Query 		:= ""
Local c_EOL			:= Chr(13)+Chr(10)
Local l_Ret			:= .T.
Local n_TotItem		:= 0
Local a_Ret			:= {}
Local c_Mens 		:= ""

If SC5->C5_XFLAGST < "10"
	
	l_Ret := .F.
	MsgStop("Primeiro deve-se realizar a liberação comercial (regras de desconto)", "PV não liberado")
	
ElseIf SC5->C5_XFLAGST == "20"
	
	l_Ret := .F.
	MsgStop("Primeiro deve-se realizar a liberação de crédito", "PV não liberado")
	
ElseIf SC5->C5_XFLAGST == "30"
	
	l_Ret := .F.
	MsgStop("Primeiro deve-se realizar a liberação de estoque", "PV não liberado")
	
ElseIf SC5->C5_XFLAGST == "32" .OR. SC5->C5_XFLAGST == "33"
	
	l_Ret := .F.
	MsgStop("Primeiro deve-se enviar esse pedido para Fiscal", "PV não liberado")


ElseIf SC5->C5_XFLAGST == "35"
	
	l_Ret := .F.
	MsgStop("Primeiro deve-se enviar esse pedido para logística", "PV não liberado")
	
ElseIf SC5->C5_XFLAGST == "10" 
	
	l_Ret := fLibPV()
	
Endif

///////////////////////////////////////////////
// Verifica se houve duplicacao na liberacao //
///////////////////////////////////////////////
If ( l_Ret )
	
	//Primeiro jah verifico se houve mais de uma liberacao
	c_Query := "SELECT COUNT(*) AS QTDREG FROM "+RetSqlName("SC9")+" (NOLOCK) "+c_EOL
	c_Query += "WHERE C9_FILIAL = '"+SC5->C5_FILIAL+"' "+c_EOL
	c_Query += "AND C9_PEDIDO = '"+SC5->C5_NUM+"' "+c_EOL
	c_Query += "AND C9_SEQUEN > '01' "+c_EOL
	c_Query += "AND D_E_L_E_T_ = ' ' "+c_EOL
	
	If Select("RS") > 0
		RS->(DbCloseArea())
	Endif
	
	TcQuery c_Query New Alias "RS"
	
	If ( RS->QTDREG > 0 )
		l_Ret := .F.
		
		//Verifico se a quantidade liberada esta diferente da quantidade do pedido
	Else
		
		DbSelectArea("SC9")
		DbSetOrder(1) //C9_FILIAL, C9_PEDIDO, C9_ITEM, C9_SEQUEN, C9_PRODUTO, R_E_C_N_O_, D_E_L_E_T_
		DbSeek(xFilial("SC9")+SC5->C5_NUM, .F.)
		
		While ( SC9->(!Eof()) .And. SC9->(C9_FILIAL+C9_PEDIDO) == xFilial("SC9")+SC5->C5_NUM .And. l_Ret)
			
			DbSelectArea("SC6")
			DbSetOrder(1) //C6_FILIAL, C6_NUM, C6_ITEM, C6_PRODUTO, R_E_C_N_O_, D_E_L_E_T_
			If DbSeek(xFilial("SC6")+SC9->(C9_PEDIDO+C9_ITEM+C9_PRODUTO), .F.)
				
				If ( SC6->C6_QTDVEN <> SC9->C9_QTDLIB )
					
					l_Ret := .F.
					MsgStop("Atenção. Ocorreu algum problema durante o processo de liberação desse pedido, pois a quantidade liberada para faturamento "+;
					"está diferente da quantidade no pedido de vendas. "+c_EOL+c_EOL+;
					"Nº Pedido...........: "+SC6->C6_NUM+c_EOL+;
					"Item.....................: "+SC6->C6_ITEM+c_EOL+;
					"Produto..............: "+SC6->C6_PRODUTO+c_EOL+;
					"Quantidade PV...: "+Transform(SC6->C6_QTDVEN, "@E 9,999,999.99")+c_EOL+;
					"Quantidade Lib...: "+Transform(SC9->C9_QTDLIB, "@E 9,999,999.99")+c_EOL+c_EOL+;
					"Favor refazer a liberação desse pedido.", "Inconsistência - P.E. MBRWBTN")
					
				Endif
				
			Endif
			SC9->(DbSkip())
		Enddo
		
	Endif
	
Endif

If l_Ret
	If AllTrim(SC5->C5_XORIGEM) == "GDCPVPLT"
		If !FSLDPALETE(SC5->C5_FILIAL, SC5->C5_NUM)
			l_Ret := .F.
		EndIf
	EndIf
EndIf

//Verifica se o pedido já possui Guia de Embarque, se não tiver, alerta o operador
If ( l_Ret .And. Empty(SC5->C5_XGSAIDA) )
	
	l_Ret := MsgNoYes("Atenção. O Pedido " + SC5->C5_NUM + " esta sem GUIA DE EMBARQUE."+Chr(13)+Chr(10)+Chr(13)+Chr(10)+;
							"Tem certeza que deseja prosseguir?", "><)))º> PEDIDO SEM GUIA")
	
Endif

RestArea(a_AreaSC6)
RestArea(a_AreaATU)

Return l_Ret
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MBRWBTN   ºAutor  ³  Tiago Dantas Cruz - Focus Consultoria  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Programa que exibe uma tela para o usuario com as opcoes   º±±
±±º          ³ para localizar o fornecedor/cliente                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Entrada como Beneficiamentos/Dev/Complementos              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function IncDocEnt(cFunc)

Local a_AreaSA1 := SA1->(GetArea())
Local a_AreaSA2 := SA2->(GetArea())

Local o_TelaDI
Local l_Ret 	:= .T.
Local l_Forn 	:= .F.
Local a_Dados	:= {}
Local c_Titulo	:=	Iif(( cFunc=="MATA103"),"Inclusao de documento de entrada","Inclusao de Pre Nota de entrada")
Local n_OpcDI   := 0

Public c_xNumDI := Space(10)

While .T.
	n_Opc := 2
	c_tpnf:=""
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Declaracao de Variaveis                                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	n_Opcoes 	:= 	1
	a_tpnf		:=	{"N=Normal","D=Devolucao","B=Beneficiamento","I=Compl. ICMS","P=Compl. IPI","C=Compl. Preço/Frete"}
	c_CNPJSA2	:= 	Space(14)
	c_CNPJSA1	:= 	Space(14)
	c_CodFor 	:= 	Space(06)
	c_LojaFor 	:= 	Space(02)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Criacao da Interface                                                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	@ 135,171 To 262,550 Dialog mkwCP Title OemToAnsi(c_Titulo)
	@ 010,009 SAY "Tipo da Nota"
	@ 005,080 COMBOBOX oCbo Var c_tpnf ITEMS a_tpnf SIZE 075,021 of mkwCP pixel
	oCbo:BCHANGE:={|| fCliFor(c_tpnf)}
	@ 017,080 MSGet o_CNPJSA2 Var c_CNPJSA2  Size 76,10 F3 "YE2" Picture "@R 99.999.999/9999-99" When (n_Opcoes==1) pixel
	@ 029,080 MSGet o_CodFor Var c_CodFor  Size 40,10 F3 "YE3" When (n_Opcoes==2) pixel
	@ 029,120 MSGet o_LojaFor Var c_LojaFor Size 13,10 When (n_Opcoes==2) pixel
	@ 020,009 Radio o_Opcoes Var n_Opcoes Items "C.N.P.J.", "Forn./Clie. Estrangeiro" SIZE 65,010 pixel
	o_Opcoes:BCHANGE:={|| Iif(n_Opcoes==1,o_CNPJSA2:SetFocus(), o_CodFor:SetFocus())}
	@ 045,066 BmpButton Type 1 Action (n_Opc:=1, Close(mkwCP))
	@ 045,115 BmpButton Type 2 Action (n_Opc:=2, Close(mkwCP))
	Activate Dialog mkwCP Centered
	
	If 	n_Opc == 2//Opcao de finalizacao
		l_Ret := .F.
		Exit
	Else//Opcao de finalizacao
		If !(Empty(c_CNPJSA2) .And. (Empty(c_CodFor) .And. Empty(c_LojaFor))) //Caso Nada preenchido
			If (Left(c_tpnf,1) $ "D/B")//Devolucao ou beneficiamento
				If n_Opcoes == 1 //CNPJ - F3
					Dbselectarea("SA1")//Cliente
					Dbsetorder(3)//A1_FILIAL, A1_CGC
					If !DBSeek(xFilial("SA1")+c_CNPJSA2, .F.)//Acha CNPJ Cliente
						MsgStop("Cliente não Localizado no cadastro com este CNPJ. Favor verificar.", "I N C O N S I S T Ê N C I A")
					Else
						l_acho:=.F. //Variavel de erro
						While(!SA1->(Eof()) .And. SA1->A1_CGC ==c_CNPJSA2)//Naum pode escolher cnpj de alguem internacional e nem bloqueado
							If SA1->A1_MSBLQL <>"1" .And. SA1->A1_EST <> "EX"
								l_acho:=.T.
								Exit
							EndIf
							SA1->(DbSkip())
						EndDO
						If l_acho=.F.
							MsgStop("Cliente Inválido. Favor verificar.", "I N C O N S I S T Ê N C I A")
						Else
							Exit
						EndIf
					Endif
				Elseif n_Opcoes == 2//CODIGO & LOJA	- F3
					Dbselectarea("SA1")//Cliente
					Dbsetorder(1)//A1_FILIAL, A1_COD, A1_LOJA
					If !DBSeek(xFilial("SA1")+c_CodFor+c_LojaFor, .F.)//Acha Codigo/Loja Cliente
						MsgStop("Cliente não Localizado no cadastro com este Codigo/Loja. Favor verificar.", "I N C O N S I S T Ê N C I A")
					Else
						If n_Opcoes == 2 .And. SA1->A1_EST <> "EX" .OR. SA1->A1_MSBLQL =="1" //Naum pode escolher codigo/Loja de alguem nacional e nem bloqueado
							MsgStop("Cliente Inválido. Favor verificar.", "I N C O N S I S T Ê N C I A")
						Else
							Exit
						EndIf
					Endif
				EndIf// FIM -F3
			Else//Nao eh Devolucao ou beneficiamento
				If n_Opcoes == 1 //CNPJ - F3
					Dbselectarea("SA2")//Fornecedor
					Dbsetorder(3)//A2_FILIAL, A2_CGC
					If !DBSeek(xFilial("SA2")+c_CNPJSA2, .F.)//Acha CNPJ Fornecedo
						MsgStop("Fornecedor não Localizado no cadastro com este CNPJ. Favor verificar.", "I N C O N S I S T Ê N C I A")
					Else
						l_acho:=.F.
						While(!SA2->(Eof()) .And. SA2->A2_CGC ==c_CNPJSA2)//Naum pode escolher codigo/Loja de alguem internacional nem bloqueado
							If SA2->A2_MSBLQL <> "1" .And. SA2->A2_EST <> "EX"
								l_acho:=.T.
								l_Forn:=.T.
								Exit
							EndIf
							SA2->(DbSkip())
						EndDO
						If l_acho=.F.
							MsgStop("Fornecedor Inválido. Favor verificar.", "I N C O N S I S T Ê N C I A")
						Else
							Exit
						EndIf
					Endif
				Elseif n_Opcoes == 2//CODIGO & LOJA	- F3
					Dbselectarea("SA2")
					Dbsetorder(1)//A2_FILIAL, A2_COD, A1_LOJA
					If !DBSeek(xFilial("SA2")+c_CodFor+c_LojaFor, .F.)//Acha Codigo/Loja Fornecedor
						MsgStop("Fornecedor não Localizado no cadastro com este Codigo/Loja. Favor verificar.", "I N C O N S I S T Ê N C I A")
					Else
						If n_Opcoes == 2 .And. SA2->A2_EST <> "EX" .OR. SA2->A2_MSBLQL =="1"//Naum pode escolher codigo/Loja de alguem nacional nem bloqueado
							MsgStop("Fornecedor Inválido. Favor verificar.", "I N C O N S I S T Ê N C I A")
						Else
							Exit
						EndIf
					Endif
				EndIf// FIM - F3
			EndIf
		Else
			MsgStop("Preencha o Codigo ou CNPJ do Fornecedor/Cliente", "I N C O N S I S T Ê N C I A")
		EndIf
	Endif//Opcao de finalizacao
	
EndDo

Public C_FORN_F1 := Iif((Left(c_tpnf,1) $ "D/B"),SA1->A1_COD,SA2->A2_COD)
Public C_LOJA_F1 := Iif((Left(c_tpnf,1) $ "D/B"),SA1->A1_LOJA,SA2->A2_LOJA)
Public C_TIPO_F1 := Left(c_tpnf,1)
Public C_EST 	 := Iif((Left(c_tpnf,1) $ "D/B"),SA1->A1_EST,SA2->A2_EST)

If l_Forn .And. !(Left(c_tpnf,1) $ "D/B")
	a_Dados := U_ALTFORNEC(c_CNPJSA2)
	If Len(a_Dados) > 0
		C_FORN_F1 := a_Dados[1][1] 
		C_LOJA_F1 := a_Dados[1][2]
		C_EST 	  := a_Dados[1][3]
	EndIf
EndIf

//Se o tipo da nota for normal, para fornecedor estrangeiro e o parametro estiver ativo 
If l_Ret .And. cFunc <> "MATA103" .And. GetMV("MV_XUNQDI")

	If c_tpnf == "N" .And. n_Opcoes == 2
		Define MSDialog o_TelaDI From 096,009 To 260,175 Title "Documento de Importação" Pixel Style DS_MODALFRAME //Dialog sem o botao para fechar a tela
		@ 018,006 Say "Favor informar o número da DI:" Size 120,008 Of o_TelaDI Pixel
		@ 032,006 MSGet c_xNumDI Picture "@!" Size 060,008 Of o_TelaDI Pixel 
		Define SButton From 060,052 Type 1 Action (l_Ret := fValidDI(), o_TelaDI:End()) Enable Of o_TelaDI
		o_TelaDI:lEscClose := .F. //Nao permite sair ao se pressionar a tecla ESC.
		o_TelaDI:Refresh()
		Activate MSDialog o_TelaDI Center
	EndIf

EndIf

RestArea(a_AreaSA2) 
RestArea(a_AreaSA1) 

Return l_Ret

/*********************************************************************************************/

Static Function fValidDI()

Local l_Ret := .T.
Local a_AreaSF1 := SF1->(GetArea())

DbSelectArea("SF1")
DbOrderNickName("XNUMDI")

If Len(AllTrim(c_xNumDI)) <> 10
	MsgInfo("É obrigatório o preenchimento do número da DI com 10 caracteres.","ATENCAO")
	l_Ret := .F.
ElseIf DbSeek(cFilAnt + AllTrim(c_xNumDI))
	MsgInfo("Já existe a nota fiscal " + AllTrim(SF1->F1_DOC) + "/" + AllTrim(SF1->F1_SERIE) + " vinculada com a DI " + AllTrim(c_xNumDI) + ".","ATENCAO")
	l_Ret := .F.
EndIf

RestArea(a_AreaSF1)

Return l_Ret

/*********************************************************************************************/

Static Function fCliFor(c_tpnf)

If Left(c_tpnf,1) $ "D/B"
	o_CNPJSA2:CF3:="YE1"
	o_CodFor:CF3:="SA1"
Else
	o_CNPJSA2:CF3:="YE2"
	o_CodFor:CF3:="YE3"
Endif

Return nil

/*********************************************************************************************/

Static Function fLibPV()

Local l_Ret		:= .T.
Local a_AreaATU	:= GetArea()
Local c_BkpcCad := cCadastro

l_Ret := fVerLib()

If l_Ret
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica as perguntas selecionada                    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Pergunte("MTA440",.F.)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Transfere locais para a liberacao                    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	PRIVATE lTransf:=MV_PAR01==1
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Libera Parcial pedidos de vendas                     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	PRIVATE lLiber :=MV_PAR02==1
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Sugere quantidade liberada                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	PRIVATE lSugere:=MV_PAR03==1
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Ativa tecla F12 para alterar parametro                   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	SetKey(VK_F12,{||Pergunte("MTA440",.T.),;
	lTransf:=MV_PAR01==1,;
	lLiber :=MV_PAR02==1,;
	lSugere:=MV_PAR03==1})
	
	cCadastro := "Liberação de Pedido de Venda"
	//Padrao Microsiga
	A440Libera("SC5",SC5->(Recno()),6)
	
	If SC5->C5_XFLAGST == "10"
		l_Ret := .F.
		MsgStop("Atenção! O pedido não foi liberado!", "Ped. sem lib.")
	ElseIf SC5->C5_XFLAGST == "20"
		l_Ret := .F.
		MsgStop("Atenção! O pedido ficou no bloqueio de Crédito", "Bloq. Crédito")
	ElseIf SC5->C5_XFLAGST == "30"
		l_Ret := .F.
		MsgStop("Atenção! O pedido ficou no bloqueio de Estoque", "Bloq. Estoque")
	ElseIf SC5->C5_XFLAGST == "32"
		l_Ret := .F.
		MsgStop("Atenção! O pedido ficou aguardando liberação fiscal", "Bloq. Lib. Fiscal")
	ElseIf SC5->C5_XFLAGST == "35"
		l_Ret := .F.
		MsgStop("Atenção! O pedido ficou aguardando liberação para logística", "Bloq. Lib. Logistica")
	Endif
	
	cCadastro := c_BkpcCad
	SetKey(VK_F12,{|| a410Ativa()})
	
Endif

RestArea(a_AreaATU)

Return l_Ret

/*********************************************************************************************/

Static Function fVerLib()

Local l_Ret		:= .T.
Local a_UsrFunc	:= U_GDCVerProg("MATA440")
Local i			:= 0

For i := 1 To Len(a_UsrFunc)
	If a_UsrFunc[i][1] == cEmpAnt .And. a_UsrFunc[i][2] == cFilAnt .And. AllTrim(a_UsrFunc[i][3]) <> AllTrim(cUserName)
		MsgStop("A Rotina de liberação de pedidos só pode ser executada por um usuário de cada vez e nesse "+;
		"momento o usuário "+AllTrim(a_UsrFunc[i][3])+" está utilizando-a.", "Acesso exclusivo")
		l_Ret := .F.
		Exit
	Endif
Next i

Return l_Ret

/*********************************************************************************************/

Static Function fAjtLib()

Local c_Query	:= ""
Local c_EOL		:= Chr(13)+Chr(10)

c_Query += "SELECT C6_FILIAL, C6_NUM, C6_ITEM, C6_QTDVEN, C6_QTDENT, C6_QTDEMP, SUM(ISNULL(C9_QTDLIB, 0)) AS C9_QTDLIB  "+c_EOL
c_Query += "FROM "+RetSqlName("SC5")+" AS SC5  "+c_EOL
c_Query += " "+c_EOL
c_Query += "INNER JOIN "+RetSqlName("SC6")+" AS SC6  "+c_EOL
c_Query += "	ON C6_FILIAL = C5_FILIAL  "+c_EOL
c_Query += "	AND C6_NUM = C5_NUM  "+c_EOL
c_Query += "	AND SC6.D_E_L_E_T_ = ' '  "+c_EOL
c_Query += " "+c_EOL
c_Query += "LEFT JOIN "+RetSqlName("SC9")+" AS SC9  "+c_EOL
c_Query += "	ON C9_FILIAL = C6_FILIAL  "+c_EOL
c_Query += "	AND C9_PEDIDO = C6_NUM  "+c_EOL
c_Query += "	AND C9_ITEM = C6_ITEM  "+c_EOL
c_Query += "	AND SC9.D_E_L_E_T_ = ' '  "+c_EOL
c_Query += " "+c_EOL
c_Query += "WHERE C5_FILIAL = '"+cFilAnt+"'  "+c_EOL
c_Query += "AND ( C5_NOTA = '' OR C5_XFLAGST <> '50' ) "+c_EOL
c_Query += "AND SC5.D_E_L_E_T_ = ' '  "+c_EOL
c_Query += " "+c_EOL
c_Query += "GROUP BY C6_FILIAL, C6_NUM, C6_ITEM, C6_QTDVEN, C6_QTDEMP, C6_QTDENT  "+c_EOL
c_Query += "HAVING C6_QTDEMP <> SUM(ISNULL(C9_QTDLIB, 0))  "+c_EOL
c_Query += "AND C6_QTDVEN > C6_QTDENT "+c_EOL

If Select("QRYLIB") > 0
	QRYLIB->(DbCloseArea())
Endif

TcQuery c_Query New Alias "QRYLIB"

DbSelectArea("QRYLIB")
DbGoTop()

DbSelectArea("SC6")
DbSetOrder(1) //C6_FILIAL, C6_NUM, C6_ITEM, C6_PRODUTO, R_E_C_N_O_, D_E_L_E_T_

While QRYLIB->(!Eof())
	
	If SC6->(DbSeek(QRYLIB->C6_FILIAL+QRYLIB->C6_NUM+QRYLIB->C6_ITEM, .F.))
		RecLock("SC6", .F.)
		SC6->C6_QTDEMP := QRYLIB->C9_QTDLIB
		MsUnLock()
	Endif
	
	QRYLIB->(DbSkip())
Enddo

QRYLIB->(DbCloseArea())

Return Nil

//***************************************************************************************************************

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³fVldCliente| Autor ³ Claudio Dias Junior (Focus Consultoria)  | Data ³ 25/03/09 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Funcao para validar se o cliente esta bloqueado ou nao.                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nil   => Nenhum.                                                               ³±±
±±³          ³ OBSERVACAO: Deve estar posicionado na tabela SC5                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ l_Ret => Se .T. Cliente nao bloqueado, prossegue com a funcionalidade          ³±±
±±³          ³          Se .F. Cliente bloqueado.                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Específico³ Especifico GDC Alimentos                                                		  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Analista Resp.³  Data  ³ Manutencao Efetuada                                       		  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Erisom Pimenta³01/02/10³Validar o cliente somente se pedido nao usar fornecedor.           ³±±
±±³              ³  /  /  ³                                               				 	  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function fVldCliente()

Local l_Ret		:= .T.                           
Local a_AreaATU	:= GetArea()
Local a_AreaSA1	:= SA1->(GetArea())
Local a_AreaSA2	:= SA2->(GetArea())

If ( !SC5->C5_TIPO $ "B#D" )                        
	DbSelectArea("SA1")
	DbSetOrder(1)                 
	If ( !DbSeek(xFilial("SA1")+SC5->(C5_CLIENTE+C5_LOJACLI), .F.) )
		l_Ret := .F.
		MsgStop("Não foi possível localizar o Cliente ["+SC5->C5_CLIENTE+"] Loja ["+SC5->C5_LOJACLI+"] no cadastro de clientes.", "Inconsistência")
	ElseIf ( SA1->A1_MSBLQL == "1" .Or. SA1->A1_XBLQCOM == "1" )
		l_Ret := .F.
		MsgStop("O Cliente.: " + SC5->C5_CLIENTE + " Loja.: " + SC5->C5_LOJACLI + " está bloqueado! Favor veficar situação do mesmo, para dar continuidade no processo.", "Inconsistência")
	ElseIf ( SA1->A1_EST == "EX" .And. (Empty(SA1->A1_PAIS)) ) //83264
		l_Ret := .F.
		MsgStop("O Cliente.: " + SC5->C5_CLIENTE + " Loja.: " + SC5->C5_LOJACLI + " está com o PAÍS em branco! Favor veficar situação do mesmo, para dar continuidade no processo.", "Inconsistência")
	EndIf
Else
	DbSelectArea("SA2")
	DbSetOrder(1)                 
	If ( !DbSeek(xFilial("SA2")+SC5->(C5_CLIENTE+C5_LOJACLI), .F.) )
		l_Ret := .F.
		MsgStop("Não foi possível localizar o Fornecedor ["+SC5->C5_CLIENTE+"] Loja ["+SC5->C5_LOJACLI+"] no cadastro de Fornecedores.", "Inconsistência")
	ElseIf ( SA2->A2_MSBLQL == "1" )
		l_Ret := .F.
		MsgStop("O Fornecedor.: " + SC5->C5_CLIENTE + " Loja.: " + SC5->C5_LOJACLI + " está bloqueado! Favor veficar situação do mesmo, para dar continuidade no processo.", "Inconsistência")
	EndIf
EndIf                               

RestArea(a_AreaSA2)
RestArea(a_AreaSA1)
RestArea(a_AreaATU)
      
Return l_Ret
//***************************************************************************************************************

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ fVlCCusto | Autor ³Tiago Dantas da Cruz (Focus Consultoria)  | Data ³ 10/12/10 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Funcao para validar se o centro de custo esta bloqueado ou nao.                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nil   => Nenhum.                                                               ³±±
±±³          ³ OBSERVACAO: Deve estar posicionado na tabela SC5                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ l_Ret => Se .T. Cliente nao bloqueado, prossegue com a funcionalidade          ³±±
±±³          ³          Se .F. Cliente bloqueado.                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Específico³ Especifico GDC Alimentos                                                		  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Analista Resp.³  Data  ³ Manutencao Efetuada                                       		  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³              ³  /  /  ³                                               					  ³±±
±±³              ³  /  /  ³                                               				 	  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function fVlCCusto(c_Chave)
      
Local a_AreaATU		:=	GetArea()
Local a_AreaSC6		:=	SC6->(GetArea())
Local a_AreaSF4		:= 	SF4->(GetArea())
Local l_Ret			:= .T.
Local c_EOL			:= Chr(13)+Chr(10)
Local c_ExibeMens 	:= ""
Local c_XVLCCPV		:= GetMV("MV_XVLCCPV")

DbSelectArea("SC6")
DbSetOrder(1) //C6_FILIAL, C6_NUM, C6_ITEM, C6_PRODUTO, R_E_C_N_O_, D_E_L_E_T_
DbSeek(xFilial("SC6")+SC5->C5_NUM, .F.)

While ( SC6->(!Eof()) .And. SC6->(C6_FILIAL+C6_NUM) == c_Chave .And. l_Ret )

	DbSelectarea("SF4")
	DbSetOrder(1) //F4_FILIAL, F4_CODIGO, R_E_C_N_O_, D_E_L_E_T_
	If ( DbSeek(xFilial("SF4")+SC6->C6_TES, .F.) )
		If ( SF4->F4_GRCTB $ c_XVLCCPV )
			If ( Empty(SC6->C6_CCUSTO) )
				l_Ret := .F.
				c_ExibeMens += "Pedido/Produto: "+SC6->C6_NUM+"/"+AllTrim(SC6->C6_PRODUTO)+" está sem centro de custo."+c_EOL
			Else
				DbSelectArea("CTT")
				DbSetOrder(1)//CTT_FILIAL, CTT_CUSTO, R_E_C_N_O_, D_E_L_E_T_
				If ( !Dbseek(xFilial("CTT")+SC6->C6_CCUSTO, .F.) )
					l_Ret := .F.
					c_ExibeMens += "Centro de custo: "+SC6->C6_CCUSTO+" não foi localizado no cadastro."+c_EOL
				ElseIf( !ValidaBloq(SC6->C6_CCUSTO, dDataBase, "CTT") )
					l_Ret := .F.
					c_ExibeMens += "O Centro de Custo ["+SC6->C6_CCUSTO+"] está bloqueado."+c_EOL
				EndIf
			Endif
		EndIf
	Else
		l_Ret := .F.
		c_ExibeMens += "TES ["+Alltrim(SC6->C6_TES)+"] não localizada no cadastro."+c_EOL
	EndIf

	SC6->(DBskip())

EndDo

If ( !l_Ret )
	MsgStop(c_ExibeMens, "><((((º> - Gomes da Costa.")
EndIf

RestArea(a_AreaSF4)
RestArea(a_AreaSC6)
RestArea(a_AreaATU)
      
Return l_Ret

/***************************************************************************************************************/

User Function GDCPREPDOC(l_MbrwBtn, a_ItLibPV)

Local l_Ret 		:= .T.
Local l_VdaBon	:= .F.
Local a_AreaATU	:= GetArea()
Local a_AreaSC5	:= SC5->(GetArea())
                        
//Verifica se o cliente do PV esta bloqueado
If !fVldCliente()
	l_Ret := .F.
	
//Verifica se o(s) centro(s) de custo do PV esta(o) bloqueado(s)
ElseIf !fVlCCusto(SC5->(C5_FILIAL+C5_NUM))
	l_Ret := .F.

//Validacao Itens do Pedido	
ElseIf !fVldItensGeral(l_MbrwBtn, a_ItLibPV)
	l_Ret := .F.

//Verifica se existe desconto indevido no PV (Chamado: 15.084) -OK
ElseIf !U_VldDescon(SC5->C5_FILIAL, SC5->C5_NUM)
	l_Ret := .F.
	
//Verifica se eh possivel faturar um pedido de bonificacao
ElseIf !u_fVldBonif(SC5->C5_FILIAL, SC5->C5_NUM)
	l_Ret := .F.
	
//Verifica se o EAN GLN está preenchido caso o cliente esteja cadastrado no PAG
ElseIf !u_fVLDEAN(SC5->C5_FILIAL, SC5->C5_NUM)
	l_Ret := .F.

ElseIf !fVldPCF()
	l_Ret := .F.
	
ElseIf !fVldSolBa()
	l_Ret := .F.	
	
ElseIf !fVldSarAt()
	l_Ret := .F.
	
//Desse ponto em diante, valida apenas se foi acionado via P.E. MBRWBTN
ElseIf ( l_MbrwBtn )
	
	//Para garantir, caso alguem tenha disposicionado o pedido
	RestArea(a_AreaSC5)
	
	l_FatSer4 	:= .F.
	
	If ( SC5->C5_FILIAL == "05" .And. SC5->C5_XDPFEC == "1" )
		l_FatSer4 := .T.			
	Endif
	
	l_Ret := fVldPV()
	
Endif

RestArea(a_AreaATU)

Return l_Ret

/***************************************************************************************************************/

Static Function fVldItensGeral(l_MbrwBtn, a_ItLibPV)

Local l_Ret 			:= .T.
Local l_LocalOK		:= .T.
Local c_LocCerto		:= ""
Local l_DeuErro		:= .F.
Local l_VdaBon		:= .F.
Local c_ExibeMens	:= ""
Local c_EOL				:= Chr(13) + Chr(10)
Local n_PesMaxPV		:= GetMv("MV_XPESOPV")
Local a_AreaATU		:= GetArea()
Local a_AreaSF4		:= SF4->(GetArea())
Local a_AreaSB2		:= SB2->(GetArea())
Local a_AreaSA1		:= SA1->(GetArea())

DbSelectArea("SC6")
SC6->(DbSetOrder(1))
SC6->(DbGoTop())
SC6->(DbSeek(xFilial("SC6")+SC5->C5_NUM, .F.))

DbSelectArea("SF4")
SF4->(DbSetOrder(1))//F4_FILIAL, F4_CODIGO, R_E_C_N_O_, D_E_L_E_T_

DbSelectArea("SB2")
SB2->(DbSetOrder(1))//B2_FILIAL, B2_COD, B2_LOCAL, R_E_C_N_O_, D_E_L_E_T_

While ( SC6->(!Eof()) .And. SC6->(C6_FILIAL+C6_NUM) == xFilial("SC6")+SC5->C5_NUM .And. l_Ret )
	
	//Verifica se existe saldo para fazer a baixa no almox de terceiro
	If GetMV("MV_CONTERC")		
		If SF4->(DbSeek(xFilial("SF4")+SC6->C6_TES))
			If SF4->F4_ESTOQUE == 'N' .And. SF4->F4_PODER3 == 'R' .And. SF4->F4_CONTERC <> '2'
				If SB2->(DbSeek(xFilial("SB2")+SC6->(C6_PRODUTO+C6_LOCAL)))
					If SC6->C6_QTDVEN > (SB2->B2_QATU - SB2->B2_RESERVA)
						MsgStop("Saldo insuficiente para o produto " + AllTrim(SC6->C6_PRODUTO) + ".","ATENCAO")
						l_Ret := .F.
						Exit
					EndIf
				EndIf
			EndIf
		EndIf 
	EndIf
	
	//////////////////////////////////////////////////////////////////////////////
	// Verifica se armazem está respeitando regra de Nosso em Poder de Terceiro //
	//////////////////////////////////////////////////////////////////////////////
	If ( SC6->C6_FILIAL == "05" ) //Venda da Fabrica
		
		//Saindo do Deposito Fechado
		If ( ( SC5->C5_XDPFEC == "1" .And. SC6->C6_LOCAL <> "F5" ) .Or. ( SC5->C5_XDPFEC <> "1" .And. SC6->C6_LOCAL == "F5" ) )
			l_LocalOK == .F.
			c_LocCerto := "F5"
			
			//Saindo da Embalagens
		ElseIf ( ( SC5->C5_XDPFEC == "2" .And. SC6->C6_LOCAL <> "F6" ) .Or. ( SC5->C5_XDPFEC <> "2" .And. SC6->C6_LOCAL == "F6" ) )
			l_LocalOK == .F.
			c_LocCerto := "F6"
		EndIf
		
	ElseIf ( SC6->C6_FILIAL == "20" ) //Venda da Embalagens
		
		//Saindo do Deposito Fechado
		If ( ( SC5->C5_XDPFEC == "1" .And. SC6->C6_LOCAL <> "F2" ) .Or. ( SC5->C5_XDPFEC <> "1" .And. SC6->C6_LOCAL == "F2" ) )
			l_LocalOK == .F.
			c_LocCerto := "F2"
		EndIf
		
	EndIf
	
	If ( l_LocalOK == .F. )
		l_Ret := .F.
		
		MsgStop("Filial "+SC6->C6_FILIAL+" - Pedido "+SC6->C6_NUM +" configurado para sair "+;
		IIF(SC5->C5_XDPFEC == "1", "do Depósito Fechado", "da Embalagens")+" (C5_XDPFEC = '"+SC5->C5_XDPFEC+"') "+;
		"Porém o armazem do pedido ("+SC6->C6_LOCAL+") está diferente de "+c_LocCerto+c_EOL+c_EOL+;
		"Favor revisar o pedido", "I N C O N S I S T Ê N C I A")
	Endif
	///////////////////////////////////
	// Fim da Verificacao do Armazem //
	///////////////////////////////////
	
	//////////////////////////////////////////////////////
	// Verifico se TODOS os Itens estão sendo atendidos //
	//////////////////////////////////////////////////////
	If ( !l_MbrwBtn )
		
		//Se vem da rotina MBRWBTN tenho que carregar o array com os itens liberados
		//If ( l_MbrwBtn )
		//	a_ItLibPV := fGetLibs(SC6->(C6_FILIAL+C6_NUM+C6_ITEM))
		//Endif

		//Tenho que pesquisar porque esse array a_ItLibPV pode ter vindo do P.E. M460MARK
		n_Pos := aScan(a_ItLibPV, { |x| x[1] == SC6->(C6_FILIAL+C6_NUM+C6_ITEM) } )

		If n_Pos == 0
			l_DeuErro := .T.
			c_ExibeMens += "Pedido/Produto: "+SC6->C6_NUM+"/"+AllTrim(SC6->C6_PRODUTO)+" Não selecionado para faturar."+c_EOL
		ElseIf a_ItLibPV[n_Pos][2] <> SC6->C6_QTDVEN  .AND. !fLote()// CH 17759 - Valido se controla lote
			l_DeuErro := .T.
			c_ExibeMens += "Pedido/Produto: "+SC6->C6_NUM+"/"+AllTrim(SC6->C6_PRODUTO)+c_EOL+;
			"      Qtd. PV = "+AllTrim(Str(SC6->C6_QTDVEN))+"  | Qtd. marcada para Faturar = "+AllTrim(Str(a_ItLibPV[n_Pos][2]))+" "+c_EOL
		Else
			//Verifico se foi liberado a mais ou a menos
			If ( SC6->C6_QTDVEN <> SC6->C6_QTDEMP ) .AND. !fLote()//CH 17759 - Valido se controla lote
				l_DeuErro := .T.
				c_ExibeMens += "Pedido/Produto: "+SC6->C6_NUM+"/"+AllTrim(SC6->C6_PRODUTO)+c_EOL+;
				"      Qtd. PV = "+AllTrim(Str(SC6->C6_QTDVEN))+"  | Qtd. liberada para Faturar = "+AllTrim(Str(SC6->C6_QTDEMP))+" "+c_EOL
			Endif
			
		Endif
	
	Endif
	////////////////////////////////////////////////////////////////
	// Fim da Verificacao se TODOS os Itens estão sendo atendidos //
	////////////////////////////////////////////////////////////////


	/////////////////////////////////////////
	// Verifico se eh Venda ou Bonificacao //
	/////////////////////////////////////////
	If ( l_Ret .And. !l_VdaBon ) 
		l_VdaBon := U_fEhVdaOuBon(SC6->C6_FILIAL, SC6->C6_TES,,SC6->C6_PRODUTO, .F.)
	Endif
	
	////////////////////////////////////////////////////////////////
	// Verifico se eh pode movimentar estoque com data retroativa //
	////////////////////////////////////////////////////////////////
	If !U_GVLDME(SC6->C6_TES) 
		l_Ret := .F.
	EndIf

	If ( SC6->C6_CLI == "999999" .And. SC6->C6_LOCAL == "85" )
		l_Ret := .F.
		MsgStop("Não é permitido faturar Pedidos para o Almoxarifado 85.","INCONSISTÊNCIA")
	Endif
	
	//Verifico se pode faturar por conta da integração com o WMS
	If !fVldIntWMS()
		l_Ret := .F.
	EndIf
	
	//////////////////////////////////////////////////////
	// 81377 - Verifico se a NCM esta bloqueada         //
	//////////////////////////////////////////////////////
	If l_Ret	
		If SM0->M0_CODIGO == "03"
			DbSelectArea("SB1")
			DbSetOrder(1)
			DbSeek(xFilial("SB1")+SC6->C6_PRODUTO, .F.)
			
			If !Empty(SB1->B1_POSIPI) 
				DbSelectArea("SYD")
				DbSetOrder(1) // B1_FILIAL+B1_COD
				DbGoTop()
				If DbSeek(xFilial("SYD") + SB1->B1_POSIPI)
					If SYD->YD_MSBLQL == "1"
						MsgStop("A NCM do produto "+AllTrim(SB1->B1_COD)+" está bloqueada! ! ! Por favor entrar em contato com o responsável pelo cadastro de produtos, no ramal 2624, para que revise o cadastro de produtos!")
						l_Ret := .F.
					EndIf
				Else
					MsgStop("NCM não existe na tabela de NCM´s", "Erro")
					l_Ret := .F.
				Endif
			EndIf
		EndIf
	EndIf
	//////////////////////////////////////////////////////
	//    Fim da Verificacao se a NCM esta bloqueada    //
	//////////////////////////////////////////////////////

	DbSelectArea("SA1")
	DbSetOrder(1)
	DbSeek(xFilial("SA1")+SC5->(C5_CLIENTE+C5_LOJACLI), .F.)
	
	If ( SA1->A1_EST == "EX" .And. (Empty(SA1->A1_PAIS)) ) //83264
		l_Ret := .F.
		MsgStop("O Cliente.: " + SC5->C5_CLIENTE + " Loja.: " + SC5->C5_LOJACLI + " está com o PAÍS em branco! Favor veficar situação do mesmo, para dar continuidade no processo.", "Inconsistência")
	EndIf
	
	//Vai para o próximo item
	SC6->(DbSkip())
	
Enddo

/* Inicio 90541 - Retirada da validação de peso na liberação fiscal.

If ( l_Ret .And. l_VdaBon )

	If ( SC5->C5_XPESOB > n_PesMaxPV .And. SC5->C5_TPFRETE <> "F" .And. SC5->C5_EST <> "EX" )
		
		l_Ret := .F.
		MsgStop("Peso máximo permitido [ "+Transform(n_PesMaxPV, "@E 999,999.99")+" ]. Peso do pedido [ "+Transform(SC5->C5_XPESOB, "@E 999,999.99")+" ].","I N C O N S I S T Ê N C I A")
		
	EndIf

Endif

Fim 90541 */

If ( l_DeuErro )
	
	l_Ret := .F.
	
	// Arquivo de Log.
	AutoGrLog( "Registro do Processo" )
	AutoGrLog( "-----------------" )
	AutoGrLog( "DataBase.: "+Dtoc(dDataBase) + " Data.: "+Dtoc(MsDate()) + " Hora.: "+Time() )
	AutoGrLog( "Environment.: "+GetEnvServer() + " Versão.: "+GetVersao() + " Módulo.: "+"SIGA"+cModulo  )
	AutoGrLog( "Empresa/Filial.: "+cEmpAnt+"/"+cFilant + " Usuário.: "+cUserName )
	AutoGrLog( " " )
	AutoGrLog( " GDC -  Preparação de Notas Fiscais " )
	AutoGrLog( " ---------------------------- " )
	AutoGrLog( "Não será possível faturar os itens selecionados por causa dos problemas abaixo" )
	AutoGrLog( " " )
	AutoGrLog( c_ExibeMens )
	AutoGrLog( " " )
	
	MostraErro()
	
Endif

RestArea(a_AreaATU)
RestArea(a_AreaSF4)
RestArea(a_AreaSB2)
RestArea(a_AreaSA1)

Return l_Ret

/***************************************************************************************************************/

Static Function fGetLibs(c_ChvItem)

Local a_ItensLib := {}
Local a_AreaATU	:= GetArea()
Local n_ItPV		:= 0

DbSelectArea("SC9")
DbSetOrder(1) //C9_FILIAL, C9_PEDIDO, C9_ITEM, C9_SEQUEN, C9_PRODUTO, R_E_C_N_O_, D_E_L_E_T_
DbSeek(c_ChvItem, .F.)

While ( SC9->(!Eof()) .And. SC9->(C9_FILIAL+C9_PEDIDO+C9_ITEM) == c_ChvItem )
	
	If ( Empty(SC9->C9_NFISCAL) .And. Empty(SC9->C9_BLEST) .And. Empty(SC9->C9_BLCRED) .And. Empty(SC9->C9_XBLQLOG) )
		
		n_ItPV := aScan(a_ItensLib, { |x| x[1] == SC9->(C9_FILIAL+C9_PEDIDO+C9_ITEM)} )
		If ( n_ItPV == 0 )
			aAdd(a_ItensLib, {SC9->(C9_FILIAL+C9_PEDIDO+C9_ITEM), SC9->C9_QTDLIB})
		Else
			a_ItensLib[n_ItPV][2] += SC9->C9_QTDLIB
		Endif
		
	Endif

	SC9->(DbSkip())
Enddo

RestArea(a_AreaATU)

Return a_ItensLib

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    | FSLDPALETE³ Autor ³ Flavio Valentin       ³ Data ³ 28/01/15 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Funcao usada para validar estoque do palete.                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nenhum.                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ l_Ret => .T. ou .F.                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Analista Resp.³  Data  ³ Manutencao Efetuada                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³              |        ³                                                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function FSLDPALETE(c_C5Fil, c_C5Num)

Local a_Areax := GetArea()
Local l_Ret   := .T.
Local c_QryC6 := ""
Local c_EOL   := CHR(13) + CHR(10)

c_QryC6 := " SELECT SC5.C5_FILIAL, SC5.C5_NUM, SC5.C5_EMISSAO, SC5.C5_LOJACLI, C6_PRODUTO, C6_LOCAL, SC9.C9_QTDLIB, SC9.C9_PRCVEN, " + c_EOL
c_QryC6 += " SC9.C9_DATALIB, SC9.C9_BLEST " + c_EOL
c_QryC6 += " FROM "+RetSqlName("SC5")+" SC5 (NOLOCK) " + c_EOL
c_QryC6 += " INNER JOIN "+RetSqlName("SC6")+" SC6 (NOLOCK) ON SC6.C6_FILIAL = SC5.C5_FILIAL AND SC6.C6_NUM = SC5.C5_NUM AND SC6.D_E_L_E_T_ = ' ' " + c_EOL
c_QryC6 += " INNER JOIN "+RetSqlName("SC9")+" SC9 (NOLOCK) ON SC9.C9_FILIAL = SC6.C6_FILIAL AND SC9.C9_PEDIDO = SC6.C6_NUM AND SC9.C9_ITEM = SC6.C6_ITEM " + c_EOL
c_QryC6 += " AND SC9.C9_PRODUTO = SC6.C6_PRODUTO " + c_EOL
c_QryC6 += " AND C9_NFISCAL = ' ' " + c_EOL
c_QryC6 += " AND C9_SERIENF = ' ' " + c_EOL
c_QryC6 += " AND C9_BLCRED = ' ' " + c_EOL
c_QryC6 += " AND C9_BLEST = ' ' " + c_EOL
c_QryC6 += " AND SC9.D_E_L_E_T_ = ' ' " + c_EOL
c_QryC6 += " WHERE SC5.C5_FILIAL = '"+AllTrim(c_C5Fil)+"' " + c_EOL
c_QryC6 += " AND SC5.C5_NUM = '"+AllTrim(c_C5Num)+"' " + c_EOL
c_QryC6 += " AND SC5.D_E_L_E_T_ = ' ' " + c_EOL

If Select("Q_SC6") > 0
	Q_SC6->(dbCloseArea())
EndIf

MemoWrite("FSLDPALETE_GDCPVPLT.Sql", c_QryC6)
TcQuery c_QryC6 New Alias "Q_SC6"

Q_SC6->(dbGotop())
Do While Q_SC6->(!Eof())
	
	dbSelectArea("SB2")
	dbSetOrder(1)//B2_FILIAL, B2_COD, B2_LOCAL, R_E_C_N_O_, D_E_L_E_T_
	dbSeek(Q_SC6->C5_FILIAL+Q_SC6->C6_PRODUTO+Q_SC6->C6_LOCAL)
	If SB2->B2_QATU < Q_SC6->C9_QTDLIB
		l_Ret := .F.
		MsgStop("Não existe saldo suficiente no almoxarifado " + Q_SC6->C6_LOCAL + " para o produto " + Q_SC6->C6_PRODUTO + "." ,"SEM SALDO")
		Exit
	EndIf
	
	Q_SC6->(dbSkip())
	
EndDo

RestArea(a_Areax)

Return(l_Ret)

/***********************************************************************************************************/

Static Function fLote()

Local l_Pode	:= .T.

DbSelectArea("SB1")
DbSetOrder(1)
If ( DbSeek(xFilial("SB1")+SC6->C6_PRODUTO, .F.) )

	If ( SB1->B1_RASTRO == "N" )
		l_Pode = .F.
	EndIf

Endif

Return l_Pode

/***********************************************************************************************************/

Static Function fVldPCF()

Local l_Ret := .T.

If SC5->C5_XEXCPCF == "1"
	l_Ret := .F.
	MsgStop("Não é permitido faturar o pedido, pois esta disponivel para exclusão no PCF, Para gerar a Nota Fiscal deverá ser incluso um novo pedido.","INCONSISTÊNCIA")
EndIf     

//Alerta o usuário que o pedido foi gerado automaticamente
If l_Ret .And. AllTrim(SC5->C5_XORIGEM) == "PCF"
	If !MsgYesNo("O pedido "+SC5->C5_NUM+" foi gerado automaticamente e deve ser revisado, deseja continuar com a geração da NF?","ATENCAO")
		l_Ret := .F.
	EndIf
EndIf

Return l_Ret

/***********************************************************************************************************/

Static Function fVldSolBa()

Local l_Ret		:= .T.
Local c_TipoPV	:= ""
Local l_Ret	:= .T.
Local a_AreaATU := GetArea()
Local a_AreaSC6 := SC6->(GetArea())
Local a_AreaSF4 := SF4->(GetArea())

c_TipoPV := SC5->C5_TIPO

If c_TipoPV $ "NB"
	
	DbSelectArea("SC6")
	SC6->(DbSetOrder(1))
	SC6->(DbGoTop())
	SC6->(DbSeek(xFilial("SC6") + SC5->C5_NUM))
	
	DbSelectArea("SF4")
	SF4->(DbSetOrder(1))//F4_FILIAL, F4_CODIGO, R_E_C_N_O_, D_E_L_E_T_
	
	While SC6->(!Eof()) .And. SC6->(C6_FILIAL + C6_NUM) == SC5->(C5_FILIAL + C5_NUM)
		SF4->(DbSeek(xFilial("SF4")+SC6->C6_TES))
		If SF4->F4_ESTOQUE == "S" .And. AllTrim(SF4->F4_CF) + AllTrim(SF4->F4_GRCTB) $ GetMV("MV_XSBCFOP") .And. Empty(SC5->C5_XSOLBAI) .AND. !( SC6->C6_LOCAL == "82" ) //#75301
			MsgStop("Não é possível preparar o documento de saída para pedidos de baixa de estoque, sem o vínculo da solicitação aprovada.","INCONSISTÊNCIA")
			l_Ret := .F.
			Exit	
		EndIf
		SC6->(DbSkip())
	EndDo

EndIf

RestArea(a_AreaATU)
RestArea(a_AreaSC6)
RestArea(a_AreaSF4)

Return l_Ret

/***********************************************************************************************************/

Static Function fVldSarAt()

Local l_Ret	:= .T.
Local a_AreaATU := GetArea()
Local a_AreaSC6 := SC6->(GetArea())
Local a_AreaSB1 := SB1->(GetArea())
Local l_Sard 	:= .F.
Local l_Atum 	:= .F.
Local l_Caval 	:= .F.

DbSelectArea("SC6")
SC6->(DbSetOrder(1))
SC6->(DbGoTop())
SC6->(DbSeek(xFilial("SC6") + SC5->C5_NUM))

DbSelectArea("SB1")
SB1->(DbSetOrder(1))//B1_FILIAL, B1_COD, R_E_C_N_O_, D_E_L_E_T_

While SC6->(!Eof()) .And. SC6->(C6_FILIAL + C6_NUM) == SC5->(C5_FILIAL + C5_NUM)

	SB1->(DbSeek(xFilial("SB1")+SC6->C6_PRODUTO))

	//Tratamento para Atum x Sardinha no mesmo pedido
	If Left(SB1->B1_GRUPO, 1) == "1"
		l_Sard := .T.
	ElseIf Left(SB1->B1_GRUPO, 1) == "2"
		l_Atum := .T.
	ElseIf Left(SB1->B1_GRUPO, 1) == "3"
		l_Caval := .T.
	Endif
	
	SC6->(DbSkip())
	
EndDo

If ( l_Atum .Or. l_Caval ) .And. l_Sard .And. SC5->C5_CLIENTE == "999999" .And. SC5->C5_LOJACLI == "09"	
	If !MsgYesNo("O pedido " + SC5->C5_NUM + " possui Sardinha e ( Atum ou Cavalinha ) que possuem tratamentos diferentes no TES. Deseja continuar? ","I N C O N S I S T Ê N C I A")
		l_Ret := .F.
	Endif
Endif

RestArea(a_AreaATU)
RestArea(a_AreaSC6)
RestArea(a_AreaSB1)

Return l_Ret

/***********************************************************************************************************/

Static Function fVldIntWMS()

Local l_Ret 		:= .T.
Local l_IntAtiva	:= GetMV("MV_XFATWMS")

DbSelectArea("SB1")
DbSetOrder(1) //B1_FILIAL, B1_COD, R_E_C_N_O_, D_E_L_E_T_
DbSeek(xFilial("SB1")+SC6->C6_PRODUTO, .F.)

If ( !Empty(SC5->C5_XGSAIDA) .And. SB1->B1_XWMS == "1" .And. SC6->C6_LOCAL $ "#F5#F2")

	DbSelectArea("SZT")
	DbSetOrder(1) //ZT_FILIAL, ZT_NUM, R_E_C_N_O_, D_E_L_E_T_
	If DbSeek(xFilial("SZT")+SC5->C5_XGSAIDA, .F.)
	
		//Verifico se a Guia foi feita na filial 11
		If ( SZT->ZT_ORIGEM == "11" .And. l_IntAtiva )
		
			If ( SZT->ZT_INTWMS <> "5" )
				l_Ret := .F.
				MsgStop("O pedido "+SC5->C5_NUM+" ainda não pode ser faturado pois a Guia de Embarque "+;
							"nº "+SC5->C5_XGSAIDA+" ainda não foi totalmente separada.", "><)))ª> MBRWBTN/MV_XFATWMS - Prep. Doc")
			Endif
			
		Endif
	
	Endif
	
Endif

Return l_Ret
/***********************************************************************************************************/

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄ»±±
±±³Programa  ³ GrvCNfe  ³ Autor ³ Michael M Castro   ³ Data ³  05/05/17   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Busca a Filial da Nota para trazer a Chave e Gravar na SF1 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico GDC Alimentos                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Analista Resp.³  Data  ³ Manutencao Efetuada                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³              ³        ³                                               ³±±
±±³              ³        ³                                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function GrvCNfe()

	Local c_ChvFil := ""
	Local n_Opc := 0

	If SF1->F1_TIPO $ "B/D"
		c_ChvFil := "CLJ"+SF1->F1_LOJA
	Else
		c_ChvFil := "FLJ"+SF1->F1_LOJA
	EndIf

	DbSelectArea("SX5")
	DbSetOrder(1)
	If DbSeek(xFilial("SX5")+"ZD"+c_ChvFil, .F.)

		DbSelectArea("SF2")
		DbSetOrder(1)
		If DbSeek(AllTrim(SX5->X5_DESCRI)+SF1->F1_DOC+SF1->F1_SERIE)
						
			n_Opc := Aviso("Atualização - CHVNFE","Foi encontrado a Chave NFE da nota de saída ["+SF1->F1_DOC+"] - serie ["+SF1->F1_SERIE+"] para o (fornecedor/cliente) ["+SF1->F1_FORNECE+"] / loja ["+SF1->F1_LOJA+"].  "+Chr(10)+Chr(10)+;
				"Numero da Chave: ["+SF2->F2_CHVNFE+"]."+Chr(10)+Chr(10)+; 
				"Os dados estão corretos?",{"Sim","Não"},,"" )
						
			If n_Opc == 1 // 1= Sim - A chave está correta para a Nota a ser Classificada
				RecLock("SF1", .F.)
				Replace SF1->F1_CHVNFE	With SF2->F2_CHVNFE
				MsUnlock()
			EndIf  

		EndIf

		SF2->(DbCloseArea())

	EndIf
Return

/***********************************************************************************************************/

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄ»±±
±±³Programa  ³ fValida  ³ Autor ³Felipe Azevedo Reis ³ Data ³  27/09/17   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Funcao utilizado para desenvolvimento e manutencao.        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico GDC Alimentos                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Analista Resp.³  Data  ³ Manutencao Efetuada                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³              ³        ³                                               ³±±
±±³              ³        ³                                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function fValida()

If GetMV("MV_XACESSO")
	Alert("Funcao: " + AllTrim(c_Funcao) + " | Botão: " + AllTrim(Str(n_Botao)) + " | Descricao: " + AllTrim(c_NomOpc))
EndIf

Return Nil

/***********************************************************************************************************/

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄ»±±
±±³Programa  ³fEstPVTRF ³ Autor ³Felipe Azevedo Reis ³ Data ³  20/11/17   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Funcao valida o estorno de pedido de transferencia.        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico GDC Alimentos                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Analista Resp.³  Data  ³ Manutencao Efetuada                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³              ³        ³                                               ³±±
±±³              ³        ³                                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function fEstPVTRF()

Local a_AreaATU := GetArea()
Local a_AreaSD3 := SD3->(GetArea())
Local l_Ret		:= .T.  

DbSelectArea("SD3")
DbOrderNickName("D3IDPCF") //D3_FILIAL, D3_XLOTPCF, R_E_C_N_O_, D_E_L_E_T_
DbGoTop()
If DbSeek( xFilial("SD3") + "SC5"+SC5->(C5_FILIAL+C5_NUM) )
	If SD3->D3_EMISSAO <= GetMV("MV_ULMES") .Or. SD3->D3_EMISSAO <= GetMV("MV_DBLQMOV")
		MsgInfo("Não é possível excluir o pedido, pois a data de emissão da movimentação é menor que a data do último fechamento ou do bloqueio de movimento.")
		l_Ret := .F. 
	EndIf
EndIf

RestArea(a_AreaSD3)
RestArea(a_AreaATU)

Return l_Ret