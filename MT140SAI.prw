#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ MT140SAI ³ Autor ³Felipe Azevedo dos Reis³ Data ³ 07/01/16 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Ponto de entrada no final da rotina de Pre-NF de Entrada.  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico Gomes da Costa                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Analista Resp.³  Data  ³ Manutencao Efetuada                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Felipe Reis   ³25/05/17³Ch. 63679 - Aprovacao de pre nota.         	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Felipe Aguiar ³13/03/18³Ch. 72167 - Vincular CTE a NF de compras       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Felipe Reis   ³04/07/19³Ch. 88709 - Duplicacao tela de entrada         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function MT140SAI()

Local a_AreaAtu := GetArea()
//CH 74524 - LOG
Local a_VarsLog	:= {MsDate(), Time(), ""} //[1]-Data; [2]-Hora; [3]-Observacao

Local a_AreaSD1 := SD1->(GetArea())
Local a_AreaSB1 := SB1->(GetArea())

Local a_SD1 	:= {} 
Local c_CCusto	:= ""
Local c_ItemCC	:= ""
Local c_CContab	:= ""

n_Tipo 	:= PARAMIXB[1]
c_Nota 	:= PARAMIXB[2]
c_Serie := PARAMIXB[3]
c_Forn	:= PARAMIXB[4]
c_Loja	:= PARAMIXB[5]
n_Conf	:= PARAMIXB[7] //1 => Confirmacao da execucao / 0 => Acao cancelada

//Envia Pre nota para o PC-Factory
If (n_Tipo == 3 .Or. n_Tipo == 4)  .And. n_Conf == 1 
	U_ExpNFEPCF({c_Nota, c_Serie, c_Forn, c_Loja, '1', SF1->F1_FILIAL})
ElseIf n_Tipo == 5 .And. n_Conf == 1
	U_ExpNFEPCF({c_Nota, c_Serie, c_Forn, c_Loja, '2', SF1->F1_FILIAL})
EndIf

//Atualiza status para aprovacao da pre-nota
If (n_Tipo == 3 .Or. n_Tipo == 4) .And. n_Conf == 1

	//Atualiza centro de custo quando a pre nota de peixe vir via Totvs Colaboracao
	If IsInCallStack("COMXCOL")
	
		DbSelectArea("SD1")
		SD1->(DbSetOrder(1))//D1_FILIAL, D1_DOC, D1_SERIE, D1_FORNECE, D1_LOJA, D1_COD, D1_ITEM, R_E_C_N_O_, D_E_L_E_T_
		SD1->(DbGoTop())
		SD1->(DbSeek(SF1->(F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA)))
		
		DbSelectArea("SB1")
		SB1->(DbSetOrder(1))//B1_FILIAL, B1_COD
		
		
		While SD1->(!Eof()) .And. SD1->(D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA) == SF1->(F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA)
			//Verifica se tem centro de custo e se o tipo produto nao e excecao
			If Left(SB1->B1_GRUPO,1) == "5" .And. SB1->B1_XTIPO = 'IN' .And. !Empty(SD1->D1_XPEDPCF) 
				RecLock("SD1",.F.)
				SD1->D1_CC := GetMV("MV_XPNFCCP")
				SD1->(MsUnlock())
			EndIf
			
			// ID 72167: Este trecho trabalha em conjunto com o PE COLF1D1
			//Verifico se eh um Conhecimento de Frete referente a compras
			If ALLTRIM(SF1->F1_ESPECIE) == 'CTE'
					
					c_CCusto  := ""
					c_ItemCC  := ""
					c_CContab := ""
					
					a_SD1 	:= SD1->(GetArea())
					c_Prod	:= SD1->D1_COD
					c_NfOri := SD1->D1_NFORI
							
					DbSelectArea("SD1")
					SD1-> ( DbGoTop())
					SD1-> ( DbSetOrder(2))//D1_FILIAL, D1_COD, D1_DOC, D1_SERIE, D1_FORNECE, D1_LOJA, R_E_C_N_O_, D_E_L_E_T_
					If SD1->( DbSeek(xFilial("SD1")+c_Prod+c_NfOri))
					
							//Pego o Centro de Custo da NF Origem que posiocionei para gravar no Item do CTE
							c_CCusto  := SD1->D1_CC
							c_ItemCC  := SD1->D1_ITEMCTA
							c_CContab := SD1->D1_CONTA
							
					EndIf
												
					RestArea(a_SD1)
					
					//Neste momento ja estou posicionado no SD1 do CTE novamente para gravar o CC
					RecLock("SD1",.F.)
						SD1->D1_CC 		:= c_CCusto
						SD1->D1_ITEMCTA := c_ItemCC
						SD1->D1_CONTA	:= c_CContab    
					SD1->(MsUnlock())
					
												
			EndIf
			// FIM 72167
			
			SD1->(DbSkip())
			
		EndDo
		
	EndIf

	U_AtuNFApv()
	
EndIf

//Preenche o numero da DI, se existir
If n_Tipo == 3 .And. n_Conf == 1
	If Type("c_xNumDI") <> "U" // Variavel publica preenchida no P.E. MBRWBTN
		RecLock("SF1",.F.)
		REPLACE SF1->F1_XDI WITH AllTrim(c_xNumDI)
		SF1->(MSUnlock())
		c_xNumDI := ""
	EndIf
EndIf

//Provisorio para nao aparecer a tela de CNPJ 2x - Ch.88709
If Type("l_UNQPreNF") <> "U" 
	l_UNQPreNF := .F.
EndIf

//CH 74524 - LOG
U_GrvLogFunc("MT140SAI", a_VarsLog)

RestArea(a_AreaSB1)
RestArea(a_AreaSD1)
RestArea(a_AreaATU)

Return Nil

/*********************************************************************************************/

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ MT140SAI ³ Autor ³Felipe Azevedo dos Reis³ Data ³ 09/06/17 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Rotina responsavel por atualizar status de aprovada da NFE.³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function AtuNFApv()

Local l_Continua := .F.

//Valida se a filial e o tipo da nota participa do processo de aprovacao
If SF1->F1_FILIAL $ GetMV("MV_XPNFFIL") .And. SF1->F1_TIPO $ GetMV("MV_XPNFTIP")

	DbSelectArea("SD1")
	SD1->(DbSetOrder(1))//D1_FILIAL, D1_DOC, D1_SERIE, D1_FORNECE, D1_LOJA, D1_COD, D1_ITEM, R_E_C_N_O_, D_E_L_E_T_
	SD1->(DbGoTop())
	SD1->(DbSeek(SF1->(F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA)))
	
	DbSelectArea("SB1")
	SB1->(DbSetOrder(1))//B1_FILIAL, B1_COD

	//Verifica se tem centro de custo e se o tipo produto nao e excecao
	While SD1->(!Eof()) .And. SD1->(D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA) == SF1->(F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA)
		SB1->(DbSeek(xFilial("SB1")+SD1->D1_COD))
		If !Empty(SD1->D1_CC) .And. !(SB1->B1_TIPO $ GetMV("MV_XPNFPRD")) 
			l_Continua := .T.
			Exit
		EndIf	
		SD1->(DbSkip())
	EndDo

	//Atualiza status da pre-nota para aguardar aprovacao
	If l_Continua
		RecLock("SF1",.F.)
		SF1->F1_XAPVPRE := "*"
		SF1->(MSUnlock())
	ElseIf n_Tipo == 4
		RecLock("SF1",.F.)
		SF1->F1_XAPVPRE := ""
		SF1->(MSUnlock())
	EndIf
	
	If l_Continua
		u_MailPreNF()
	EndIf
	
EndIf

Return Nil

/***********************************************************************************/

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ MT140SAI ³ Autor ³Felipe Azevedo dos Reis³ Data ³ 09/06/17 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Rotina responsavel por atualizar status de aprovada da NFE.³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function MailPreNF()

Local c_MailHTM := ""
Local c_Assunto := "Aprovação de Pré-Nota"
Local c_MailTo 	:= ""

//Monta e-mail HTML
c_MailHTM += '<HTML><!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">'
c_MailHTM += '	<html xmlns="http://www.w3.org/1999/xhtml">'
c_MailHTM += '	<style type="text/css">'
c_MailHTM += '		.tituloPag { FONT-SIZE: 20px; COLOR: #666699; FONT-FAMILY: Arial, Helvetica, sans-serif; TEXT-DECORATION: none; font-weight: bold; }'
c_MailHTM += '		.formulario { FONT-SIZE: 10px; COLOR: #000000; FONT-FAMILY: Verdana, Arial, Helvetica, sans-serif; TEXT-DECORATION: none; font-weight: bold; }'
c_MailHTM += '		.formulario2{ FONT-SIZE: 11px; COLOR: #333333; FONT-FAMILY: Verdana, Arial, Helvetica, sans-serif; TEXT-DECORATION: none; }'
c_MailHTM += '		.formulario3{ FONT-SIZE: 11px; COLOR: #000000; FONT-FAMILY: Verdana, Arial, Helvetica, sans-serif; TEXT-DECORATION: none; font-weight: bold; }'
c_MailHTM += '		.formularioTit { FONT-SIZE: 13px; COLOR: #000000; FONT-FAMILY: Verdana, Arial, Helvetica, sans-serif; TEXT-DECORATION: none;  }'
c_MailHTM += '		.formularioTit2 { FONT-SIZE: 15px; COLOR: #FFFFFF; FONT-FAMILY: Verdana, Arial, Helvetica, sans-serif; TEXT-DECORATION: none; font-weight: bold; }'
c_MailHTM += '	</style>'
c_MailHTM += '<head>'
c_MailHTM += '	<title>GDC Alimentos - Log de Integração das SAPs com origem no Portal de Vendas </title>'
c_MailHTM += '</head>'

c_MailHTM += '<table width="95%" border="0" align="center">'
c_MailHTM += '<tr>'
c_MailHTM += '	<td colspan="4" >'
c_MailHTM += '		<img src="'+GetMV("MV_XLOGO")+'" border="0">'
c_MailHTM += '	</td>'
c_MailHTM += '<tr>'

c_MailHTM += '<tr>'
c_MailHTM += '	<td colspan="4" bgcolor="#8EBEF5">'
c_MailHTM += '		<div align="center"><span class="formularioTit2"><H2>Aviso Eletrônico</H2></span></div>'
c_MailHTM += '	</td>'
c_MailHTM += '</tr>'

c_MailHTM += '<tr>'
c_MailHTM += '	<td colspan="4">&nbsp;</td>'
c_MailHTM += '</tr>'

c_MailHTM += '<tr>'
c_MailHTM += '	<td colspan="4">
c_MailHTM += '		<span class="formularioTit">Pré-Nota ' + SF1->F1_DOC + '/' + AllTrim(SF1->F1_SERIE) + ' da filial ' + SF1->F1_FILIAL + ' está aguardando aprovação.</span>'
c_MailHTM += ' 		</span></td><br>'
c_MailHTM += ' 	</td>'
c_MailHTM += '</tr>'

c_MailHTM += '<tr>'
c_MailHTM += '	<td colspan="4">
c_MailHTM += '		<span class="formularioTit">Fornecedor ' + SF1->F1_FORNECE + '/' + AllTrim(SF1->F1_LOJA) + ' - ' + AllTrim(GetAdvfVal("SA2","A2_NOME",xFilial("SA2")+SF1->(F1_FORNECE+F1_LOJA))) + '</span>'
c_MailHTM += ' 		</span></td><br>'
c_MailHTM += ' 	</td>'
c_MailHTM += '</tr>'

c_MailHTM += '<tr>'
c_MailHTM += '	<td colspan="4">&nbsp;</td>'
c_MailHTM += '</tr>'

c_MailHTM += '<tr>'
c_MailHTM += '	<td colspan="4" bgcolor="#8EBEF5"><div align="center"><span class="formulario"><h5>Itens da Solicitação<h5></span></div></td>'
c_MailHTM += '</tr>'

c_MailHTM += '<tr>'
c_MailHTM += '	<td colspan="4">&nbsp;</td>'
c_MailHTM += '</tr>'

c_MailHTM += '<tr>'
c_MailHTM += '	<td width="05%" bgcolor="#ECF0EE" class="formulario">Item</td>'
c_MailHTM += '	<td width="15%" bgcolor="#ECF0EE" class="formulario">Produto</td>'
c_MailHTM += '	<td width="40%" bgcolor="#ECF0EE" class="formulario">Descrição</td>'
c_MailHTM += '	<td width="10%" bgcolor="#ECF0EE" class="formulario">Local</td>'
//c_MailHTM += '	<td width="10%" bgcolor="#ECF0EE" class="formulario">Quantidade</td>'
c_MailHTM += '</tr>'

DbSelectArea("SD1")
SD1->(DbSetOrder(1))//D1_FILIAL, D1_DOC, D1_SERIE, D1_FORNECE, D1_LOJA, D1_COD, D1_ITEM, R_E_C_N_O_, D_E_L_E_T_
SD1->(DbGoTop())
SD1->(DbSeek(SF1->(F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA)))

DbSelectArea("SB1")
SB1->(DbSetOrder(1))//B1_FILIAL, B1_COD

//Verifica se tem centro de custo e se o tipo produto nao e excecao
While SD1->(!Eof()) .And. SD1->(D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA) == SF1->(F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA)
	SB1->(DbSeek(xFilial("SB1")+SD1->D1_COD))
		If Empty(c_MailTo)
			DbSelectArea("PBU")
			DbSetOrder(1)//PBU_FILIAL, PBU_CCUSTO, PBU_CODUSR, R_E_C_N_O_, D_E_L_E_T_
			If DbSeek(xFilial("PBU")+SD1->D1_CC)
				PswOrder(2)				
				While PBU->(!Eof()) .And. SD1->D1_CC == PBU->PBU_CCUSTO
					PswSeek( PBU->PBU_USER , .T. )
					c_MailTo += PSWRET()[1][14] + ";"					 
					PBU->(DbSkip())
				EndDo 				
			EndIf
		EndIf
		c_MailHTM += '<tr>'
		c_MailHTM += '	<td width="05%" bgcolor="#F7F9F8" class="formulario2">' + SD1->D1_ITEM + '</td>'
		c_MailHTM += '	<td width="15%" bgcolor="#F7F9F8" class="formulario2">' + SD1->D1_COD + '</td>'
		c_MailHTM += '	<td width="40%" bgcolor="#F7F9F8" class="formulario2">' + SB1->B1_DESC + '</td>'
		c_MailHTM += '	<td width="10%" bgcolor="#F7F9F8" class="formulario2">' + SD1->D1_LOCAL + '</td>'
		//c_MailHTM += '	<td align="right" width="10%" bgcolor="#F7F9F8" class="formulario2">' + Transform(SD1->D1_QUANT, "@E 999,999,999.99") + '</td>'
		c_MailHTM += '</tr>'
	SD1->(DbSkip())
EndDo

c_MailHTM += '<tr>'
c_MailHTM += '	<td class="formulario"><p>&nbsp;</p></td>'
c_MailHTM += '</tr>'

c_MailHTM += '<tr>'
c_MailHTM += '	<td colspan="4" bgcolor="#8EBEF5"><div align="center"><span class="formulario"><h5>Informática Gomes da Costa</h5></span></div></td>'
c_MailHTM += '</tr>'

c_MailHTM += '<tr>'
c_MailHTM += '	<td colspan="4" bgcolor="#8EBEF5"><div align="center"><span class="formulario"><h5>Ajudando você no seu dia-a-dia!</h5></span></div></td>'
c_MailHTM += '</tr>'

c_MailHTM += '</table>'
c_MailHTM += '</body>'
c_MailHTM += '</html>'

//Alert("Mail TO: " + c_MailTo)

If !Empty(c_MailTo)
	U_GDCSendMail("","",GetMV("MV_RELSERV"),"0148",c_Assunto,c_MailHTM,"",c_MailTo)
EndIf

Return Nil

