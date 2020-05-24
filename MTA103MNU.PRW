#INCLUDE "TbiConn.ch"
#INCLUDE "RWMAKE.ch"
#INCLUDE "Protheus.ch"
/*UUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUU
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±UAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA?±±
±±³Programa  ³ MTA103MNU  ³ Autor ³ Douglas Viegas Franca     ³ Data ³ 06/04/11 ³±±
±±AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA?±±
±±³Descricao ³ P.E. utilizado para incluir novas opcoes no grid do documento de ³±±
±±³          ³entrada atraves da variavel aRotina (public) do pragrama MATA103. ³±±
±±AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA?±±
±±³Parametros³ Nil => Nenhum                                                    ³±±
±±AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA?±±
±±³Retorno   ³ Nil => Nenhum                                                    ³±±
±±AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA?±±
±±³Analista Resp.³  Data  ³ Manutencao Efetuada                                 ³±±
±±AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA?±±
±±³Felipe Aguiar ³04/10/11³Chamado : 14171 - Pesquisa nao estava funcionando;   ³±±
±±AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA?±±
±±³Claudio Dias  ³03/12/15³Chamado : 58452 Botao 'Clas.Ret Simb'                ³±±
±±AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA?±±
±±³              ³  /  /  ³                                                     ³±± 
±±AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAU±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function MTA103MNU()
                                                                                                                      

Local a_AreaATU	:= GetArea()
Local lImpNFE := GetMv("MV_XMLIMP",.F.,.F.) 

//??????????????????????????????????????????
//³ Utiliza sistema de importacao de XML ? ³
//?????????????????????????????????????????O
IF  lImpNFE
	aAdd(aRotina,{"Classif. Auto","IF (Empty(SF1->F1_STATUS),Processa({|| aRetProc := U_CP0108E(SF1->F1_DOC, SF1->F1_SERIE, SF1->F1_FORNECE, SF1->F1_LOJA), IF(aRetProc[1],NIL,AVISO('Falha',aRetProc[2],{'Cancelar'},3))}, 'Gerando Doc. Entrada...'),Help( ,, 'HELP',, 'Esta nota fiscal n?o pode ser classificada, verifique o Status da nota.', 1, 0))", 0 , 4, 0, nil})
ENDIF 

aAdd(aRotina, {"Pesq Doc Orig", "U_GDCMTA103MNU(1)"	, 0 , 1, 0, .F.})	
	If Upper(AllTrim(cUserName)) $ GETMV("MV_XRETSIM")
		aAdd(aRotina, {"Clas.Ret Simb", "MsgRun('Efetuando classificação automática, por favor aguarde...',,{|| U_ClassifDoc(SF1->(RECNO())) })",0 ,1,0, .F.})	
	EndIf

IF Upper(AllTrim(cUserName)) $ GETMV("MV_XUSALCH")
	aAdd(aRotina, {"Alt Chave CTE", "U_GDCAJCHV(SF1->(RECNO()))", 0 , 1, 0, .F.})	
ENDIF

RestArea(a_AreaATU)

Return Nil

/*********************************************************************************/

User Function GDCMTA103MNU(n_Opc)

//Pesquisar por documento de Origem
If ( n_Opc == 1 )
	
	//Monta Tela para capturar o DOC de Origem
	ListaNFs()
	
Endif

Return Nil

/*********************************************************************************/

Static Function ListaNFs()

Local oDlg
Local cTitulo 	:= "><)))º> Pesquisa por Documento de Origem"
Local aCab 		:= {}

Private c_NFOrig	:= Space(09)
Private c_SerOrig	:= Space(03)
Private aVetor 		:= {}
Private oLbx		:= Nil

Private n_RecSF1	:= 0

// Monta a tela para usuário visualizar consulta.
DEFINE MSDIALOG oDlg TITLE cTitulo FROM 0,0 TO 260,500 PIXEL

@ 05,010 SAY "NF Original" Pixel Of oDlg
@ 04,040 MSGET c_NFOrig SIZE 30,08 Pixel Of oDlg

@ 05,080 SAY "Série" Pixel Of oDlg
@ 04,095 MSGET c_SerOrig SIZE 20,08 Pixel Of oDlg

@ 04,120 Button "Localizar"	Size 030,010 PIXEL OF oDlg Action Pesquisar()

@ 18,10 LISTBOX oLbx FIELDS HEADER ;
							"NFiscal", "Série", "Valor R$", "Fornecedor" ;
							COLSIZES 30, 20, 45, 200 ;
							SIZE 230,95 OF oDlg PIXEL ON DblClick(n_RecSF1:=aVetor[oLbx:nAt][1],oDlg:End())
						
fAtuGrid()
                   
DEFINE SBUTTON FROM 115,213 TYPE 1 ACTION (n_RecSF1:=aVetor[oLbx:nAt][1],oDlg:End()) ENABLE OF oDlg

ACTIVATE MSDIALOG oDlg CENTER

If ( n_RecSF1 > 0 )
	SF1->(DbGoTo(n_RecSF1))
Endif

Return Nil

/*********************************************************************************/

Static Function Pesquisar()

Local c_NF		:= ""
Local c_Serie	:= ""
Local c_Forn	:= ""
Local c_Loja	:= ""

aVetor := {}

DbSelectArea("SD1")
dbOrderNickName("NFORI") //D1_FILIAL, D1_NFORI, D1_SERIORI, D1_FORNECE, D1_LOJA, D1_COD, R_E_C_N_O_, D_E_L_E_T_
DbSeek(xFilial("SD1")+c_NFOrig+IIF(Empty(c_SerOrig), "", c_SerOrig), .F.)

   
While ( SD1->(!Eof()) .And. SD1->(D1_FILIAL+D1_NFORI) == xFilial("SD1")+c_NFOrig )
	
	If ( Empty(c_SerOrig) .Or. SD1->D1_SERIORI == c_SerOrig )

		If 	(c_NF+c_Serie+c_Forn+c_Loja <> SD1->(D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA) )
	
			c_NF	:= SD1->D1_DOC
			c_Serie	:= SD1->D1_SERIE
			c_Forn	:= SD1->D1_FORNECE
			c_Loja	:= SD1->D1_LOJA
			
			DbSelectArea("SF1")
			DbSetOrder(1) //F1_FILIAL, F1_DOC, F1_SERIE, F1_FORNECE, F1_LOJA, F1_TIPO, R_E_C_N_O_, D_E_L_E_T_
			If DbSeek(xFilial("SF1")+SD1->(D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_TIPO), .F.)
				
				c_DescForn := "["+SF1->F1_FORNECE+"-"+SF1->F1_LOJA+"] "
	
				If ( SF1->F1_TIPO $ "D#B#" )
					c_DescForn += AllTrim(GetAdvFVal("SA1", "A1_NOME", xFilial("SA1")+SF1->(F1_FORNECE+F1_LOJA), 1, ""))
				Else
					c_DescForn += AllTrim(GetAdvFVal("SA2", "A2_NOME", xFilial("SA2")+SF1->(F1_FORNECE+F1_LOJA), 1, ""))
				Endif
			
				aAdd(aVetor, {SF1->(Recno()), SF1->F1_DOC, SF1->F1_SERIE, SF1->F1_VALBRUT, c_DescForn} )
			Endif
		
		Endif

	Endif
	
	SD1->(DbSkip())
	
Enddo

If Len(aVetor) == 0
	MsgStop("Nenhuma NF foi localizada.", "MTA103MNU")
Endif

fAtuGrid()

Return Nil

/*********************************************************************************/

Static Function fAtuGrid()

If Len( aVetor ) == 0
	aAdd(aVetor, {0, Space(09), Space(03), 0.00, Space(100)} )
Endif

oLbx:SetArray( aVetor )
oLbx:bLine := {|| {aVetor[oLbx:nAt,2],;
					aVetor[oLbx:nAt,3],;
					Transform(aVetor[oLbx:nAt,4], "@E 999,999,999.99"),;
					aVetor[oLbx:nAt,5]}}
					
oLbx:Refresh()

Return Nil
