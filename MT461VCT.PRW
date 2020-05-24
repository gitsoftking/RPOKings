#Include "Protheus.Ch"
#Include "Rwmake.Ch"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT461VCT  ºAutor  ³Augusto Ribeiro     º Data ³  08/04/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ O ponto de entrada MT461VCT permite alterar o valor e o    º±±
±±º          ³ vencimento do título gerado no momento de geração da nota  º±±
±±º          ³ fiscal                                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User function MT461VCT()   
Local aRet 		:= ParamIxb[1]
Local aParam	:= ParamIxb
Local lImpNFE 	:= GetMv("MV_XMLIMP",.F.,.F.)    
Local aArea		:= GetArea()    

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Utiliza sistema de importacao de XML ? ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
IF  lImpNFE 
	IF !EMPTY(SC5->C5_XCHVNFE)
		aRet	:= fGeraTit()
	ENDIF
ENDIF 
                                
RestArea(aArea)
Return(aRet)     
    


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
Static Function fGeraTit()
Local aRet 	:= {}
Local aAreaZ13   


DBSELECTAREA("Z13")
aAreaZ13	:= Z13->(GetArea())
Z13->(DBSETORDER(1))

IF Z13->(DBSEEK(XFILIAL("Z13")+SC5->C5_XCHVNFE+"S")) 
	aRet	:= {}   
              
	WHILE Z13->(!EOF()) .AND.  Z13->Z13_CHVNFE == SC5->C5_XCHVNFE .AND. Z13->Z13_TIPARQ == "S"
	        
		aadd(aRet, {Z13->Z13_DTVENC, Z13->Z13_VALOR} )

		Z13->(DBSKIP())
	ENDDO
ENDIF                


RestArea(aAreaZ13)
Return(aRet)


/*
Local  aRet 	:= {}	
Local _nValorTT := 0
Local aArea     := GetArea()
Local aAreaSD2  := SD2->(GetArea())
Local aAreaSF2  := SF2->(GetArea())
Local aAreaZ13  := Z13->(GetArea())

            
DBSELECTAREA("Z13")
Z13->(DBGOTOP())
Z13->(DBSETORDER(1)) //| Z13_FILIAL+Z13_NUMPV+Z13_PARCEL+Z13_TIPO

DBSELECTAREA("SD2")
SD2->(DBGOTOP())
SD2->(DBSETORDER(3)) //| D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA


IF Z13->(DBSEEK(XFILIAL("Z13")+SC5->C5_NUM,.F.))

	WHILE Z13->(!EOF()) .AND. Z13->Z13_NUMPV == SC5->C5_NUM
	
		aadd(aRet, {Z13->Z13_VENC, Z13->Z13_VLPARC })		

		Z13->(DBSKIP())
	ENDDO 

ELSE //| Utiliza a condicao de pagamento da Nota

	SD2->(DBSEEK(XFILIAL("SD2")+SF2->(F2_DOC+F2_SERIE+F2_CLIENTE+ F2_LOJA),.F.))

  	WHILE SD2->(!EOF()) .AND. SD2->(D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA) == SF2->(F2_DOC+F2_SERIE+F2_CLIENTE+ F2_LOJA)  

		_nValorTT += SD2->D2_TOTAL

	SD2->(DBSKIP())	
	ENDDO

	aRet := Condicao(_nValorTT,SF2->F2_COND,SF2->F2_VALIPI,dDataBase) 

ENDIF                 

RestArea(aAreaZ13)
RestArea(aAreaSF2)
RestArea(aAreaSD2)
RestArea(aArea)

Return(aRet)


*/