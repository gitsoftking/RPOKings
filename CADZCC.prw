#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TbiConn.ch" 
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ CADZCC | Autor ³Claudio Dias Junior (Focus Consultoria)   | Data ³ 08/08/16 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Cadastro de De/Para produtos GDC x Produto Fornecedor³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nenhum.                                                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nil.                                                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Específico³ GDC                                                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Analista Resp.³  Data  ³ Manutencao Efetuada                                       		 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³              ³  /  /  ³                                                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Muda outro fonte
Muda outra vez
User Function CADZCC()

Local c_Cadastro 	:= "><)))))º> - GDC Manutencao de Produtos X Fornecedor | Clientes."
Private CCADASTRO
Private aRotina

aRotina	:=  {	{"Pesq."  	    ,'AxPesqui'         ,0,1},;
				{"Visualizar"	,'U_ManutZCC(2)'	,0,2},;
				{"Incluir"		,'U_ManutZCC(3)'	,0,3},;
				{"Alterar"		,'U_ManutZCC(4)'	,0,4},;
				{"Excluir"	    ,'U_ManutZCC(6)' 	,0,6},;
				{"Reprocessar"	,'COMXCOL()'	,0,7} }

MBrowse(,,,,"ZCC",,,,)

Return Nil

//****************************************************************************************************************************************************************************//

User Function ManutZCC(n_OpcX)
	
	Local n_Usado	:= 0
	Local aC		:= {} //Campos do cabecalho
	Local aR		:= {} //Campos do rodape
	Local a_Size	:= MsAdvSize()
	Local a_CGD		:= {85,5,118,315} //{a_Size[7],a_Size[1],a_Size[6],a_Size[5]}  //Tamanho da Tela
	Local c_PrimCmp	:= ""
	Local n_LinGetD	:= 0
	Local c_Titulo	:= "Produto X Fornecedor | Cliente"
	Local nX		:= 0
	Local c_CmpCabec:= "ZCC_ORIGEM#ZCC_CLIFOR#ZCC_LOJA#ZCC_NOME#ZCC_CGC#ZCC_NREDUZ#"
	Private c_Chave := ZCC->(ZCC_FILIAL+ZCC_ORIGEM+ZCC_CLIFOR+ZCC_LOJA)
	Private c_Origem:= ""
	Private c_DesOri:= ""
	Private c_CliFor:= ""
	Private c_Loja  := ""
	Private c_Nome  := ""
	Private c_CGC   := ""
	Private aHeader	:= {}
	Private aCols	:= {}
	Private nOpc 	:= n_OpcX
	Private c_Perg  := "CADZCC"
	
	//Valida e empresa e filial que pode ter acesso
	If !(cEmpAnt == '03' .And. cFilant $ '05#20#')
		MsgInfo("Somente as filiais 05 e 20 possuem acesso para esta rotina!","Ordem de Separação")
		Return Nil
	EndIf
	
	If n_OpcX  == 3
		VALIDPERG(c_Perg)
		Pergunte(c_Perg,.T.)
		If MV_PAR01 == 1
			c_Origem := "SA2"
			c_DesOri := "Fornecedor"
		Else
			c_Origem := "SA1"
			c_DesOri := "Cliente"
		EndIf
	Else
		c_Origem := ZCC->ZCC_ORIGEM
		c_DesOri := IIF(ZCC->ZCC_ORIGEM=="SA2","Fornecedor","Cliente")
	EndIf
		
	DbSelectArea("SX3")
	DbSetOrder(1)
	DbSeek("ZCC")
	
	While !Eof() .And. (x3_arquivo == "ZCC")
		If X3USO(X3_USADO) .AND. cNivel >= x3_nivel .AND. !(AllTrim(x3_campo) $ c_CmpCabec)
			n_Usado:=n_Usado+1
			aAdd(aHeader,{ TRIM(x3_titulo),x3_campo,;
				x3_picture,x3_tamanho,x3_decimal,;
				X3_VALID,x3_usado,;
				x3_tipo, x3_arquivo, x3_context } )
		EndIf
		DbSkip()
	End
	
	//+-----------------------------------------------+
	//¦ Montando aCols para a GetDados                ¦
	//+-----------------------------------------------+
	DbSelectArea("SX3")
	DbSeek("ZCC")
	
	If n_OpcX == 3
		aCols:=Array(1,n_Usado+1)
	Else
		aCols := {}
	EndIf
	
	n_Usado:=0
	While !Eof() .And. (x3_arquivo == "ZCC")
		IF X3USO(x3_usado) .AND. cNivel >= x3_nivel .AND. !(AllTrim(x3_campo) $ c_CmpCabec)
			n_Usado:=n_Usado+1
			If n_OpcX == 3
				IF x3_tipo == "C"
					aCOLS[1][n_Usado] := SPACE(x3_tamanho)
				Elseif x3_tipo == "N"
					aCOLS[1][n_Usado] := 0
				Elseif x3_tipo == "D"
					aCOLS[1][n_Usado] := CtoD("//")
				Elseif x3_tipo == "M"
					aCOLS[1][n_Usado] := ""
				Else
					aCOLS[1][n_Usado] := .F.
				EndIf
			Endif
		Endif
		dbSkip()
	Enddo
	
	If n_OpcX <> 3
		DbSelectArea("ZCC")
		ZCC->(DbSetOrder(1))
		ZCC->(DbGoTop())
		ZCC->(DbSeek(c_Chave))
		
		c_PrimCmp  := aHeader[1][2]
		
		While ZCC->(!Eof()) .And. c_Chave == ZCC->(ZCC_FILIAL+ZCC_ORIGEM+ZCC_CLIFOR+ZCC_LOJA)
			For nX := 1 To Len(aHeader)
				If AllTrim(c_PrimCmp) == AllTrim(aHeader[nX][2])
					AADD(aCols,Array(Len(aHeader)+1))
				EndIf
				aCOLS[Len(aCols)][aScan(aHeader,{|x| AllTrim(x[2]) == AllTrim(aHeader[nX][2])})] := &("ZCC->"+AllTrim(aHeader[nX][2]))
				If nX == Len(aHeader)
					aCOLS[Len(aCols)][Len(aHeader)+1] := .F.
				EndIf
			Next nX
			ZCC->(dbSkip())
		Enddo
	Else
		aCOLS[1][n_Usado+1] := .F.
	EndIf
	
	ZCC->(DbSeek(c_Chave))
	
	//+----------------------------------------------+
	//¦ Variaveis do Cabecalho do Modelo 2           ¦
	//+----------------------------------------------+
	If n_OpcX == 3

		c_CliFor := Space(06)
		c_Loja   := Space(02)
		c_Nome 	 := Space(40)
		c_CGC 	 := Space(14)
		aAdd(aC,{"c_DesOri" ,{015,010} ,"Origem","@!",,,.F.})
		aAdd(aC,{"c_CliFor" ,{030,010} ,"Codigo","@!",IIF(c_Origem=="SA2","U_VCpoZCC(c_Origem,SA2->(A2_COD+A2_LOJA))","U_VCpoZCC(c_Origem,SA1->(A1_COD+A1_LOJA))"),c_Origem,.T.})
		aAdd(aC,{"c_Loja" 	,{030,085} ,"Loja"	,"@!",,,.F.})
		aAdd(aC,{"c_Nome"	,{030,135} ,"Nome  ","@!",,,.F.})
		aAdd(aC,{"c_CGC"	,{030,400} ,"CGC   ","@R 99.999.999/9999-99",,,.F.})
				
	Else
		
		c_CliFor := ZCC->ZCC_CLIFOR
		c_Loja   := ZCC->ZCC_LOJA
		c_Nome 	 := ZCC->ZCC_NOME
		c_CGC 	 := ZCC->ZCC_CGC
		aAdd(aC,{"c_DesOri" ,{015,010} ,"Origem","@!",,,.F.})
		aAdd(aC,{"c_CliFor" ,{030,010} ,"Codigo","@!",,,.F.})
		aAdd(aC,{"c_Loja" 	,{030,085} ,"Loja"	,"@!",,,.F.})
		aAdd(aC,{"c_Nome" 	,{030,135} ,"Nome  ","@!",,,.F.})
		aAdd(aC,{"c_CGC"	,{030,400} ,"CGC   ","@R 99.999.999/9999-99",,,.F.})		
	EndIf
	
	nOpc := n_OpcX
	
	//+----------------------------------------------+
	//¦ Validacoes na GetDados da Modelo 2           ¦
	//+----------------------------------------------+
	cLinhaOk := "U_fZCCLin()"
	cTudoOk  := ".T."
	
	//+----------------------------------------------+
	//¦ Chamada da Modelo2                           ¦
	//+----------------------------------------------+
//  lRet = .t. se confirmou// lRet = .f. se cancelou
//	lRet := Modelo2(c_Titulo,aC,aR,a_CGD,n_OpcX,cLinhaOk,,,,,,{140,15,630,900})    
	lRet := Modelo2(c_Titulo,aC,aR,a_CGD,n_OpcX,cLinhaOk,cTudoOk,{"ZCC_CODPRD","ZCC_CODPCF","ZCC_UMNFE"},,,9999999999,{a_Size[7],a_Size[1],a_Size[6],a_Size[5]})    
	
	If lRet
		Md2Alter()
	EndIf
	
Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ Md2Alter ³ Autor ³Felipe Azevedo dos Reis³ Data ³ 22/07/16 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Funcao que realiza a inclusao e alteracao de Ord. Separacao³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nil => Nenhum                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nil => Nenhum                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Analista Resp.³  Data  ³ Manutencao Efetuada                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³              ³  /  /  ³                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³              ³  /  /  ³                                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function Md2Alter()
	
	Local c_Var			:= ""
	Local n_ZCC_PRDCOD	:= aScan( aHeader, {|x| AllTrim(x[2]) == "ZCC_CODPRD"	} )
	Local n_ZCC_NOMPRD	:= aScan( aHeader, {|x| AllTrim(x[2]) == "ZCC_NOMPRD"	} )
	Local n_ZCC_PCFCOD	:= aScan( aHeader, {|x| AllTrim(x[2]) == "ZCC_CODPCF"	} )
	
	DbSelectArea("ZCC")
	DbSetOrder(1)//ZCC_FILIAL, ZCC_ORIGEM, ZCC_CLIFOR, ZCC_LOJA, ZCC_CODPRD, R_E_C_N_O_, D_E_L_E_T_
	
	For i := 1 To Len(aCols)
		
		If DbSeek(xFilial("ZCC")+c_Origem+c_CliFor+c_Loja+aCols[i][n_ZCC_PRDCOD]+aCols[i][n_ZCC_PCFCOD])
			
			RecLock("ZCC", .F.)
			If aCols[i][Len(aHeader)+1]  // A linha esta deletada.
				DbDelete()
			Else
				For j = 1 to Len(aHeader)
					If aHeader[j][10] # "V"
						c_Var := Trim(aHeader[j][2])
						Replace &c_Var. With aCols[i][j]
					Endif
				Next j
			EndIf                     // Deleta o registro correspondente.
			MsUnLock()
			DbSelectArea("ZCC")
		Else
			
			If !aCols[i][Len(aCols[i])]
				
				RecLock("ZCC", .T.)
				
				//Campos do cabecalho
				FieldPut(FieldPos("ZCC_FILIAL"), xFilial("ZCC")	)
				FieldPut(FieldPos("ZCC_ORIGEM"), c_Origem		)
				FieldPut(FieldPos("ZCC_CLIFOR"), c_CliFor		)
				FieldPut(FieldPos("ZCC_LOJA"  ), c_Loja			)
				FieldPut(FieldPos("ZCC_NOME"  ), c_Nome			)
				FieldPut(FieldPos("ZCC_CGC"   ), c_CGC			)
				
				For j = 1 to Len(aHeader)
					If aHeader[j][10] # "V"
						c_Var := Trim(aHeader[j][2])
						Replace &c_Var. With aCols[i][j]
					Endif
				Next
				
				MSUnlock()
				
			EndIf
		EndIf
	Next
	
Return Nil

//******************************************************************************************************************************************************************************//

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³fValLinha ³ Autor ³Felipe Azevedo dos Reis³ Data ³ 22/07/16 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Valida linha da ordem de separacao.                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nil => Nenhum                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nil => Nenhum                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Analista Resp.³  Data  ³ Ma?nutencao Efetuada                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³              ³  /  /  ³                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³              ³  /  /  ³                                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function fZCCLin()
	
Local l_Ret := .T.
Local n_ZCC_PRDCOD	:= aScan( aHeader, {|x| AllTrim(x[2]) == "ZCC_CODPRD"	} )
Local n_ZCC_NOMPRD	:= aScan( aHeader, {|x| AllTrim(x[2]) == "ZCC_NOMPRD"	} )
Local n_ZCC_PCFCOD	:= aScan( aHeader, {|x| AllTrim(x[2]) == "ZCC_CODPCF"	} )
	
If Empty(aCols[n][n_ZCC_PRDCOD]) .Or. Empty(aCols[n][n_ZCC_PCFCOD])
	MsgInfo("Os campos 'Cod.Produto' e 'Cod.Prod.C/F' não podem ser vazio.","><)))))º> - A V I S O!")
	l_Ret := .F.
EndIf

/*
DbSelectArea("ZCC")
DbSetOrder(1)//ZCC_FILIAL, ZCC_ORIGEM, ZCC_CLIFOR, ZCC_LOJA, ZCC_CODPRD, R_E_C_N_O_, D_E_L_E_T_
If DbSeek(xFilial("ZCC")+c_Origem+c_CliFor+c_Loja+aCols[n][n_ZCC_PRDCOD]+aCols[n][n_ZCC_PCFCOD])
	MsgInfo("Já existe um registro com esse vinculo cadastrado. Por favor efetue reveja os valores.","><)))))º> - A V I S O!")
	l_Ret := .F.
EndIf
*/
	
Return l_Ret

//******************************************************************************************************************************************************************************//

User Function VCpoZCC(c_Origem, c_Chave)

Local a_AreaATU := GetArea()
Local l_Ret	  	:= .T.

DbSelectArea(c_Origem)
DbSetOrder(1)
DbGoTop()
If DbSeek(xFilial(c_Origem)+c_Chave)
	If c_Origem == "SA1"
		If SA1->A1_MSBLQL <> "1"
			c_Loja  := SA1->A1_LOJA
			c_Nome  := SA1->A1_NOME
			c_CGC   := SA1->A1_CGC
		Else
			l_Ret := .F.
		EndIf
	Else
		If SA2->A2_MSBLQL <> "1"
			c_Loja  := SA2->A2_LOJA
			c_Nome  := SA2->A2_NOME
			c_CGC   := SA2->A2_CGC
		Else
			l_Ret := .F.
		EndIf
	EndIf
Else
	l_Ret := .F.
EndIf

If !l_Ret
	Alert("Cadastro bloqueado! Por favor selecione outroa para dar sequência.")
	c_Loja  := Space(02)
	c_Nome  := Space(100)
EndIf

RestArea(a_AreaATU)

Return l_Ret

//******************************************************************************************************************************************************************************//

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    |VALIDPERG()  ³ Autor ³ Douglas Franca        ³ Data ³ 25/06/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Verifica a existencia das perguntas criando-as caso seja       ³±±
±±³          ³necessario (caso nao existam).                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³c_Perg => Nome da Pergunta que sera criada no SX1.             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nil.                                                           ³±±
±±³          ³                                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Analista Resp.³  Data  ³ Manutencao Efetuada                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function VALIDPERG(c_Perg)

	Local a_Regs := {}

	c_Perg := c_Perg + Replicate(" ",10 - Len(c_Perg))
	aAdd(a_Regs,{c_Perg,"01","Origem:   ?","","","MV_CH5","N",01,0,1,"C","","MV_PAR01","Fornecedor","","","","","Clientes","","","","","","","","","","","","","","","","","","",""})
	U_PUTX1GDC(c_Perg,a_Regs)

Return Nil

/****************************************************************************************/

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  | ZCCMAIL   ³ Autor ³Felipe Azevedo dos Reis³ Data ³ 22/09/16 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Ch. 73745 - Envio de email avisando sobre falta de amarracao³±±
±±³          ³ do produto para retorno e cricao do XML.                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/  

User Function ZCCMAIL()

Local c_Qry := ""
Local c_EOL := Chr(13) + Chr(10)
Local c_Itens := ""
Local c_Mail  := ""

c_Qry := "SELECT    F2_FILIAL" + c_EOL
c_Qry += "		, C5_XMAILSO" + c_EOL
c_Qry += "		, C5_NUM" + c_EOL
c_Qry += "		, F2_DOC" + c_EOL
c_Qry += "		, F2_SERIE" + c_EOL
c_Qry += "		, F2_EMISSAO" + c_EOL
c_Qry += "		, CASE WHEN F2_TIPO IN ('B','D') THEN A2_CGC ELSE A1_CGC END AS A1_CGC" + c_EOL
c_Qry += "		, CASE WHEN F2_TIPO IN ('B','D') THEN A2_NOME ELSE A1_NOME END AS A1_NOME" + c_EOL
c_Qry += "		, CASE WHEN F2_TIPO IN ('B','D') THEN A2_EMAIL ELSE A1_EMAIL END AS A1_EMAIL" + c_EOL
c_Qry += "		, CASE WHEN F2_TIPO IN ('B','D') THEN A2_TEL ELSE A1_TEL END AS A1_TEL" + c_EOL
c_Qry += "		, F2_CHVNFE" + c_EOL
c_Qry += "		, D2_COD" + c_EOL
c_Qry += "		, D2_QUANT" + c_EOL
c_Qry += "		, D2_TOTAL" + c_EOL
c_Qry += "		, C5_MENNOTA" + c_EOL
c_Qry += "FROM SF2030 SF2" + c_EOL

c_Qry += "	LEFT JOIN SA2030 SA2" + c_EOL
c_Qry += "	ON A2_FILIAL = ''" + c_EOL
c_Qry += "	AND A2_COD = F2_CLIENTE" + c_EOL
c_Qry += "	AND A2_LOJA = F2_LOJA" + c_EOL
c_Qry += "	AND SA2.D_E_L_E_T_ = ''" + c_EOL

c_Qry += "	LEFT JOIN SA1030 SA1" + c_EOL
c_Qry += "	ON A1_FILIAL = ''" + c_EOL
c_Qry += "	AND A1_COD = F2_CLIENTE" + c_EOL
c_Qry += "	AND A1_LOJA = F2_LOJA" + c_EOL
c_Qry += "	AND SA1.D_E_L_E_T_ = ''" + c_EOL

c_Qry += "	INNER JOIN SC5030 SC5" + c_EOL
c_Qry += "	ON C5_FILIAL = F2_FILIAL" + c_EOL
c_Qry += "	AND C5_NUM = F2_PEDIDO" + c_EOL
c_Qry += "	AND SC5.D_E_L_E_T_ = ''" + c_EOL

c_Qry += "	INNER JOIN SD2030 SD2" + c_EOL
c_Qry += "	ON D2_FILIAL = F2_FILIAL" + c_EOL
c_Qry += "	AND D2_DOC = F2_DOC" + c_EOL
c_Qry += "	AND D2_SERIE = F2_SERIE" + c_EOL
c_Qry += "	AND D2_CLIENTE = F2_CLIENTE" + c_EOL
c_Qry += "	AND D2_LOJA = F2_LOJA" + c_EOL
c_Qry += "	AND SD2.D_E_L_E_T_ = ''" + c_EOL

c_Qry += "	INNER JOIN SF4030 SF4" + c_EOL
c_Qry += "	ON F4_FILIAL = D2_FILIAL" + c_EOL
c_Qry += "	AND F4_CODIGO = D2_TES" + c_EOL
c_Qry += "	AND SF4.D_E_L_E_T_ = ''" + c_EOL

c_Qry += "	LEFT JOIN ZCC030 ZCC" + c_EOL
c_Qry += "	ON ZCC_FILIAL = ''" + c_EOL
c_Qry += "	AND ZCC_CODPRD = D2_COD" + c_EOL
c_Qry += "	AND ZCC_CLIFOR = D2_CLIENTE" + c_EOL
c_Qry += "	AND ZCC_LOJA = D2_LOJA" + c_EOL
c_Qry += "	AND ZCC.D_E_L_E_T_ = ''" + c_EOL

c_Qry += "WHERE F2_EMISSAO = '" + DtoS((MSDate() - 1)) + "'" + c_EOL
c_Qry += "AND F2_CLIENTE <> '999999'" + c_EOL
c_Qry += "AND F2_TIPO = 'B'" + c_EOL
c_Qry += "AND (F4_PODER3 = 'R' OR F4_CF IN ('5554','6554','5901','6901','5905','6905','5912','6912','5915','6915'))" + c_EOL
c_Qry += "AND SF2.D_E_L_E_T_ = ''" + c_EOL

If Select("QRYZCC") > 0
	QRYZCC->(DbCloseArea())
Endif

TCQUERY c_Qry NEW ALIAS "QRYZCC"

While QRYZCC->(!Eof())
	c_Itens += '<tr>'
	c_Itens += '	<td  width="10%" bgcolor="#F7F9F8" class="formulario2">'+QRYZCC->F2_FILIAL+'</td>'
	c_Itens += '	<td  width="10%" bgcolor="#F7F9F8" class="formulario2">'+QRYZCC->C5_XMAILSO+'</td>'
	c_Itens += '	<td  width="10%" bgcolor="#F7F9F8" class="formulario2">'+QRYZCC->C5_NUM+'</td>'
	c_Itens += '	<td  width="10%" bgcolor="#F7F9F8" class="formulario2">'+QRYZCC->F2_DOC+'</td>'
	c_Itens += '	<td  width="10%" bgcolor="#F7F9F8" class="formulario2">'+DtoC(StoD(QRYZCC->F2_EMISSAO))+'</td>'
	c_Itens += '	<td  width="10%" bgcolor="#F7F9F8" class="formulario2">'+Transform(QRYZCC->A1_CGC,PesqPict('SA2','A2_CGC'))+'</td>'
	c_Itens += '	<td  width="30%" bgcolor="#F7F9F8" class="formulario2">'+QRYZCC->A1_NOME+'</td>'
	c_Itens += '	<td  width="30%" bgcolor="#F7F9F8" class="formulario2">'+QRYZCC->A1_EMAIL+'</td>'
	c_Itens += '	<td  width="30%" bgcolor="#F7F9F8" class="formulario2">'+QRYZCC->A1_TEL+'</td>'
	c_Itens += '	<td  width="30%" bgcolor="#F7F9F8" class="formulario2">'+QRYZCC->F2_CHVNFE+'</td>'
	c_Itens += '	<td  width="30%" bgcolor="#F7F9F8" class="formulario2">'+QRYZCC->D2_COD+'</td>'
	c_Itens += '	<td  width="30%" bgcolor="#F7F9F8" class="formulario2">'+Transform(QRYZCC->D2_QUANT,PesqPict('SD2','D2_QUANT'))+'</td>'
	c_Itens += '	<td  width="30%" bgcolor="#F7F9F8" class="formulario2">'+Transform(QRYZCC->D2_TOTAL,PesqPict('SD2','D2_TOTAL'))+'</td>'
	c_Itens += '	<td  width="30%" bgcolor="#F7F9F8" class="formulario2">'+QRYZCC->C5_MENNOTA+'</td>'
	c_Itens += '</tr>' 
	QRYZCC->(DbSkip())
EndDo

If !Empty(c_Itens)	

	c_Mail += '<HTML><!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">'
	c_Mail += '	<html xmlns="http://www.w3.org/1999/xhtml">'
	c_Mail += '	<style type="text/css">'
	c_Mail += '		.tituloPag { FONT-SIZE: 20px; COLOR: #666699; FONT-FAMILY: Arial, Helvetica, sans-serif; TEXT-DECORATION: none; font-weight: bold; }'
	c_Mail += '		.formulario { FONT-SIZE: 10px; COLOR: #000000; FONT-FAMILY: Verdana, Arial, Helvetica, sans-serif; TEXT-DECORATION: none; font-weight: bold; }'
	c_Mail += '		.formulario2{ FONT-SIZE: 11px; COLOR: #333333; FONT-FAMILY: Verdana, Arial, Helvetica, sans-serif; TEXT-DECORATION: none; }'
	c_Mail += '		.formularioTit { FONT-SIZE: 13px; COLOR: #000000; FONT-FAMILY: Verdana, Arial, Helvetica, sans-serif; TEXT-DECORATION: none;  }'
	c_Mail += '		.formularioTit2 { FONT-SIZE: 15px; COLOR: #FFFFFF; FONT-FAMILY: Verdana, Arial, Helvetica, sans-serif; TEXT-DECORATION: none; font-weight: bold; }'
	c_Mail += '		.formularioAvis { FONT-SIZE: 15px; COLOR: #FFFFFF; FONT-FAMILY: Verdana, Arial, Helvetica, sans-serif; TEXT-DECORATION: none; font-weight: bold; }'
	c_Mail += '		.formularioRod { FONT-SIZE: 15px; COLOR: #FFFFFF; FONT-FAMILY: Verdana, Arial, Helvetica, sans-serif; TEXT-DECORATION: none; font-weight: bold; }'
	c_Mail += '	</style>'
	c_Mail += '<head>'
	c_Mail += '	<title>GDC Alimentos - Amarração Cadastro de Produto</title>'
	c_Mail += '</head>'
	c_Mail += '<table width="95%" border="0" align="center">'
	c_Mail += '<tr>'
	c_Mail += '	<td colspan="8" >'
	c_Mail += '		<img src="'+GetMV("MV_XLOGO")+'" border="0">'
	c_Mail += '	</td>'
	c_Mail += '<tr>'
	c_Mail += '<tr>'
	c_Mail += '	<td colspan="20" bgcolor="#8EBEF5">'
	c_Mail += '		<div align="center"><span class="formularioTit2"><H2>Aviso Eletrônico</H2></span></div>'
	c_Mail += '	</td>'
	c_Mail += '</tr>'
	c_Mail += '<tr>'
	c_Mail += '	<td colspan="6">&nbsp;</td>'
	c_Mail += '</tr>'
	c_Mail += '<tr>'
	c_Mail += '	<td colspan="20"><span class="formularioTit">Os produtos abaixo não possuem amarração com o respectivo código do fornecedor</span></td>'
	c_Mail += '</tr>'
	c_Mail += '<tr>'
	c_Mail += '	<td colspan="6">&nbsp;</td>'
	c_Mail += '</tr>'
	c_Mail += '<tr>'
	c_Mail += '	<td colspan="20" bgcolor="#8EBEF5"><div align="center"><span class="formulario"><h5>Lista de Produtos<h5></span></div></td>'
	c_Mail += '</tr>'
	c_Mail += '<tr>'
	c_Mail += '	<td colspan="6">&nbsp;</td>'
	c_Mail += '</tr>'
	c_Mail += '<tr>'
	c_Mail += '	<td width="10%" bgcolor="#ECF0EE" class="formulario2">Filial</td>'
	c_Mail += '	<td width="10%" bgcolor="#ECF0EE" class="formulario2">E-Mail Solicitante</td>'
	c_Mail += '	<td width="10%" bgcolor="#ECF0EE" class="formulario2">Pedido</td>'
	c_Mail += '	<td width="10%" bgcolor="#ECF0EE" class="formulario2">Nota</td>'
	c_Mail += '	<td width="10%" bgcolor="#ECF0EE" class="formulario2">Emissao</td>'
	c_Mail += '	<td width="10%" bgcolor="#ECF0EE" class="formulario2">CNPJ</td>'
	c_Mail += '	<td width="10%" bgcolor="#ECF0EE" class="formulario2">Nome</td>'
	c_Mail += '	<td width="10%" bgcolor="#ECF0EE" class="formulario2">E-Mail</td>'
	c_Mail += '	<td width="15%" bgcolor="#ECF0EE" class="formulario2">Telefone</td>'
	c_Mail += '	<td width="15%" bgcolor="#ECF0EE" class="formulario2">Chave NFe</td>'
	c_Mail += '	<td width="10%" bgcolor="#ECF0EE" class="formulario2">Produto</td>'
	c_Mail += '	<td width="10%" bgcolor="#ECF0EE" class="formulario2">Qtde</td>'
	c_Mail += '	<td width="10%" bgcolor="#ECF0EE" class="formulario2">Valor</td>'
	c_Mail += '	<td width="10%" bgcolor="#ECF0EE" class="formulario2">Mensagem NF</td>'
	c_Mail += '</tr>'	
	
	c_Mail += c_Itens
	
	c_Mail += '<tr>'
	c_Mail += '	<td class="formularioRod"><p>&nbsp;</p></td>'
	c_Mail += '</tr>'
	c_Mail += '<tr>'
	c_Mail += '	<td colspan="20" bgcolor="#8EBEF5"><div align="center"><span class="formularioRod"><h5>Informática Gomes da Costa</h5></span></div></td>'
	c_Mail += '</tr>'
	c_Mail += '<tr>'
	c_Mail += '	<td colspan="20" bgcolor="#8EBEF5"><div align="center"><span class="formularioRod"><h5>Ajudando você no seu dia-a-dia</h5></span></div></td>'
	c_Mail += '</tr>'
	c_Mail += '</table>'
	c_Mail += '</body>'
	c_Mail += '</html>'
	
	U_GDCSendMail("","",GetMV("MV_RELSERV"),"0155","Amarração Cadastro de Produto",c_Mail,"","","")
	
EndIf

Return Nil