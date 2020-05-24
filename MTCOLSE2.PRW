#Include 'Protheus.ch'

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ MTCOLSE2 ³ Autor ³ Lucas Amélio (Focus)  ³ Data ³ 04/02/20 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ manipular os dados do aCols de títulos a pagar (SE2) antes ³±±
±±³          ³ da gravação do documento de entrada e do título financeiro.³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nil => Nenhum                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ a_Datas - Array com o aCols da aba duplicatas              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Analista Resp.³  Data  ³ Manutencao Efetuada                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³              ³  /  /  ³                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³              ³  /  /  ³                                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User FuncTion MTCOLSE2()

//Array
Local a_AreaATU	    := GetArea()
Local a_AreaSF1     := SF1->(GetArea())
Local a_Datas       := PARAMIXB[1] //aCols de duplicatas
Local a_Manipula    := {}

//Caracter
Local c_Contsoc     := ""
Local c_Formul      := AllTrim(cFormul)
Local c_NFOri       := ""
Local c_SerieOri    := ""
Local c_TipoRur     := AllTrim(GetAdvFVal("SA2","A2_TIPORUR",xFilial("SA2")+cA100For+cLoja,1))

//Num�rico
Local n_D1_NFORI	:= aScan( aHeader, {|x| AllTrim(x[2]) == "D1_NFORI"   } )
Local n_D1_SERIORI	:= aScan( aHeader, {|x| AllTrim(x[2]) == "D1_SERIORI" } )
Local n_D1_TES  	:= aScan( aHeader, {|x| AllTrim(x[2]) == "D1_TES"     } )
Local n_D1_TOTAL	:= aScan( aHeader, {|x| AllTrim(x[2]) == "D1_TOTAL"   } )
Local n_Opc         := PARAMIXB[2] //0-Tela de visualizaçãoo / 1-Inclusão ou Classificação
Local n_Total       := 0

Local lImpNFE 		:= GetMv("MV_XMLIMP",.F.,.F.)     //| IMPORDOR XML COMPILA|
Local aArea			:= GetArea()     //| IMPORDOR XML COMPILA|


/*--------------------------
	IMPORDOR XML COMPILA
---------------------------*/
IF  lImpNFE 
	IF TYPE("lTitNFeAuto") == "L" .AND. TYPE("aTitNf_S") == "A".AND. !EMPTY(SF1->F1_CHVNFE)
		IF lTitNFeAuto .AND. LEN(aTitNf_S) > 0
			a_Datas	:= fGeraTit(a_Datas)
		ENDIF
	ENDIF
ENDIF                                
RestArea(aArea)



//SÃ³ entro se a condiÃ§Ã£o estiver preenchida
If !Empty(cCondicao) .And. n_Opc > 0 .And. Upper(c_TipoRur) $ "F#L" .And. Upper(c_Formul) == "S" .And. Upper(cTipo) == "N"
    If Len(aCols) > 0
        //Pego o campo F4_CONTSOC e somo o total dos itens
        For i := 1 To Len(aCols)
            c_Contsoc   := AllTrim(GetAdvFVal("SF4","F4_CONTSOC",xFilial("SF4")+aCols[i][n_D1_TES],1) )
            c_NFOri     := aCols[i][n_D1_NFORI]
            c_SerieOri  := aCols[i][n_D1_SERIORI]
            n_Total     += aCols[i][n_D1_TOTAL]
        Next i
    EndIf

    //Valido se é uma nota de produtor rural
    If c_Contsoc == "1"
        DbSelectArea("SF1")
        DbSetOrder(1) //F1_FILIAL, F1_DOC, F1_SERIE, F1_FORNECE, F1_LOJA, F1_TIPO, R_E_C_N_O_, D_E_L_E_T_
        If DbSeek(xFilial("SF1")+c_NFOri+c_SerieOri+cA100For+cLoja+cTipo, .F.)
            If DateDiffDay(Date(),SF1->F1_EMISSAO) <= 90
                a_Manipula := Condicao(n_Total,cCondicao,,SF1->F1_EMISSAO)
                For x := 1 To Len(a_Datas)
                    a_Datas[x][2] := a_Manipula[x][1]
                Next x
            EndIf
        EndIf
    EndIf
EndIf

RestArea(a_AreaSF1)
RestArea(a_AreaATU)

Return a_Datas




/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ fGeraTit º Autor ³ Augusto Ribeiro	 º Data ³  08/05/2012 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Manipula a geracao de titulos a pagar conforme XML         º±±
±±º          ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function fGeraTit(aTitulo)
Local aRet 	:= aTitulo  
Local aOrig	:= aTitulo
Local cParc	:= "A"
Local aAreaZ13, nI   


DBSELECTAREA("Z13")
aAreaZ13	:= Z13->(GetArea())
Z13->(DBSETORDER(1))

IF Z13->(DBSEEK(XFILIAL("Z13")+SF1->F1_CHVNFE+"E")) 
	aRet	:= {}   
              
	nI	:= 0
	WHILE Z13->(!EOF()) .AND.  Z13->Z13_CHVNFE == SF1->F1_CHVNFE .AND. Z13->Z13_TIPARQ == "E"
	        
	  	nI++
		aadd(aRet, aClone(aOrig[1]))
		
		//| 1 PARCELA
		//| 2 VENCIMENTO
		//| 3 VALOR
		aRet[nI,1]	:= cParc
		aRet[nI,2]	:= Z13->Z13_DTVENC
		aRet[nI,3]	:= Z13->Z13_VALOR		
         
		cParc := SOMA1(cParc)
		Z13->(DBSKIP())
	ENDDO
ENDIF                


RestArea(aAreaZ13)
Return(aRet)


