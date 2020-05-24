#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MS520DEL ºAutor  ³Emerson Leal Bruno  º Data ³  12/01/2012 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de Entrada cancelamento da nota para limpar campo    º±±
±±º          ³ e deletar tabelas para estorno e Apos a Inclusao da Nota   º±±
±±º          ³ Fiscal, porem fora da Transacao.							  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ FAT                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MS520DEL()

Local aArea    		:= GetArea()   
//CH 74524 - LOG
Local a_VarsLog	:= {MsDate(), Time(), ""} //[1]-Data; [2]-Hora; [3]-Observacao

Local aAreaSF2   	:= SF2->(GetArea())
Local aAreaDCF   	:= DCF->(GetArea())
Local aAreaZBB   	:= ZBB->(GetArea())
Local aAreaSDB   	:= SDB->(GetArea())
Local cPedii    	:= ''
Local cNotaa		:= SF2->F2_DOC
Local cSeriee		:= SF2->F2_SERIE     
Local cFilconfe		:= ''
Local c_EOL       	:= Chr(13)+Chr(10)
Local lImpNFE 		:= GetMv("MV_XMLIMP",.F.,.F.) 


//UAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA?
//³ Utiliza sistema de importacao de XML ? ³
//AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAU
IF  lImpNFE
	fAltStXML()
ENDIF  

//If cFilAnt=="04" //.And. cEmpant=="00"

DbSelectArea("ZBB")
DbSetOrder(4)//ZBB_FILIAL+ZBB_NOTA                                                                                                                                             
If DbSeek(xFilial("ZBB")+cNotaa) //Numero do Pedido
	
	cOrdSepp := ZBB->ZBB_ORDSEP  
	
	//Ch. 66251 - Ajuste devido a atualizacao indevida dos registros quando o F2 desposicionado          
    If !Empty(AllTrim(cNotaa))
		//Efetua a gravacao na tabela ZBB o Status e Nota                              
		cQuery:=" Update "+RetSqlName('ZBB') +" Set ZBB_STATUS = 'P', ZBB_NOTA = '', ZBB_DATFAT = '' " 
		cQuery+=" WHERE ZBB_FILIAL='"+xFilial('ZBB')+"' AND ZBB_NOTA='"+cNotaa+"' and D_E_L_E_T_=' '"
		TcSqlExec(cQuery)
	
		Aviso('Aviso','Estornado tambem o numero da nota: ' + cNotaa + ' na ordem de separacao: '+cOrdSepp, {"OK"})
	EndIf
	
EndIf           

//Tratamento para cancelamento da conferencia na filial destino. 3 fase projeto ACD
cQuery 	:= " SELECT F2_DOC,F2_SERIE,F2_FILCONF FROM "+RetSqlName("SF2")
cQuery 	+= " WHERE F2_FILIAL = '"+xFilial("SF2")+"' AND D_E_L_E_T_ <> '*' AND F2_DOC = '"+cNotaa+"' AND F2_SERIE = '"+cSeriee+"' AND  F2_FILCONF <> '' "+c_EOL
//cQuery 	:= ChangeQuery(cQuery)          

//Felipe A. Reis - Ch.22335
If Select("QrySF2") > 0
	QrySF2->(DbCloseArea())
Endif

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QrySF2",.T.,.T.)   

If !empty(QrySF2->F2_FILCONF)
	cFilconfe := QrySF2->F2_FILCONF           
EndIf

DBSelectArea("QrySF2")

If !empty(F2_FILCONF) 
	//Delete DCF
	DbSelectArea("DCF")
	DbSetOrder(2)//DCF_FILIAL+DCF_SERVIC+DCF_DOCTO+DCF_SERIE+DCF_CLIFOR+DCF_LOJA+DCF_CODPRO
	If DbSeek(cFilconfe+'003'+cNotaa+cSeriee) //verifica na filial destino se possui itens a ser excluido da conferencia.
		While !Eof() .AND. DCF->DCF_DOCTO == cNotaa .AND. DCF->DCF_SERIE == cSeriee		
			RecLock("DCF",.F.)
			DbDelete()    //Exclui processo de conferencia na filial destino 
			MsUnlock() 				
		DBSkip()
		Enddo		
	EndIf          

	//Delete SDB
	DbSelectArea("SDB")
	DbSetOrder(6)//DB_FILIAL+DB_DOC+DB_SERIE+DB_CLIFOR+DB_LOJA+DB_SERVIC+DB_TAREFA
	If DbSeek(cFilconfe+cNotaa+cSeriee) //verifica na filial destino se possui itens a ser excluido da conferencia.
		While !Eof() .AND. SDB->DB_DOC == cNotaa .AND. SDB->DB_SERIE == cSeriee		
			RecLock("SDB",.F.)
			DbDelete()    //Exclui processo de conferencia na filial destino 
			MsUnlock() 				
		DBSkip()
		Enddo		
	Aviso('Aviso','Estornado o processo de conferencia na filial destino onde foi gerada a pre nota ' + cNotaa, {"OK"})   	
	EndIf   	


	//Delete ZAA referente a ordem de producao
	DbSelectArea("ZAA")
	DbSetOrder(5)//ZAA_FILIAL+ZAA_DOCPRO+ZAA_NUMPAL+ZAA_PRODUT
	If DbSeek(cFilconfe+cNotaa) //verifica na filial destino se possui itens a ser excluido da conferencia.
		While !Eof() .AND. ZAA->ZAA_DOCPRO == cNotaa
			RecLock("ZAA",.F.)
			DbDelete()    //Exclui processo de conferencia na filial destino para ZAA
			MsUnlock() 				
		DBSkip()
		Enddo		
	EndIf	  
EndIf

//EndIf

//CH 74524 - LOG
U_GrvLogFunc("MS520DEL", a_VarsLog)
                                
RestArea(aAreaSDB)                  
RestArea(aAreaZBB)                  
RestArea(aAreaDCF)
RestArea(aAreaSF2)
RestArea(aArea)          

Return


/*UUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUU
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±EIIIIIIIIIINIIIIIIIIIIEIIIIIIINIIIIIIIIIIIIIIIIIIIIEIIIIIINIIIIIIIIIIIII»±±
±±oPrograma  ³ fAltStXMLoAutor  ³ Augusto Ribeiro	 o Data ³  27/04/2012 o±±
±±IIIIIIIIIIIOIIIIIIIIIIEIIIIIIIIIIIIIIIIIIIIIIIIIIIIEIIIIIIIIIIIIIIIIIIII1±±
±±oDesc.     ³ IMPORTA NF-e | Altera status no painel de arquivos         o±±
±±o          ³                                                            o±±
±±EIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII?±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
???????????????????????????????????????????????????????????????????????????*/
Static Function fAltStXML()
Local aArea := GetArea()
                               

//UAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA?
//³ Inclusao de Nota Fiscal ou Classificacao ³
//AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAU
IF !EMPTY(SF2->F2_CHVNFE)
		
	//UAAAAAAAAAAAAAAAAA?
	//³Exclusao da Nota ³
	//AAAAAAAAAAAAAAAAAAU
	aAreaZ10	:= Z10->(GetArea())
	                
	DBSELECTAREA("Z10")
	Z10->(DBSETORDER(1))	//| Z10_FILIAL, Z10_CHVNFE
	IF Z10->(DBSEEK(XFILIAL("Z10")+SF2->F2_CHVNFE+"S",.F.))
	    
		RECLOCK("Z10",.F.)
			Z10->Z10_STATUS	:= "2"		
		MSUNLOCK()
	ENDIF
	  
	RestArea(aAreaZ10)
ENDIF
      
RestArea(aArea)
Return()
