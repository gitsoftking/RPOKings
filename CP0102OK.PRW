#INCLUDE "Protheus.ch"
#INCLUDE "RWMAKE.ch"
#INCLUDE "TopConn.ch"
#INCLUDE "TBICONN.CH"

#DEFINE EOL			Chr(13)+Chr(10)  

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � CP0102OK �Autor  � Augusto Ribeiro	 � Data �  04/12/2010 ���
�������������������������������������������������������������������������͹��
���Desc.     � 	Apos as validacaoes padroes e Antes do Envio para ExecAuto���
���          � Arrays passados por referencia                             ���
���          �                                                            ���
���Desc.2    � Realiza a amarra��o com Pedido de Compra                   ���
���          �                                                            ���
���Parametros� lAuto - Rotina executada em background                     ���
���          � aCabecNF - Cabecalho da Pre-Nota                           ���
���          � aItens   - Itens Pre-Nota                                  ���
���          �                                                            ���
���Retorno   � aRet (lGeraPrenota, Msg de erro)                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
User Function CP0102OK(lAuto, aCabecNF, aItensNF,aPosIpiAux)
//Local aRet		:= {.F., "x", nil, .F. } // Posi��o 3 do Array tratamento quantidate de caracteres F1_DOC, Posi��o 4 se transfer�ncia entre filiais ocorreu com sucesso
//substitu�da linha acima pela abaixo [Mauro Nagata, www.compila.com.br, 20200302]
Local aRet		:= {.F., "", nil, .F. } // Posi��o 3 do Array tratamento quantidate de caracteres F1_DOC, Posi��o 4 se transfer�ncia entre filiais ocorreu com sucesso
Local aTranfFil
Local aCabecNF
Local aItensNF
Local aPosIpiAux

Local aItens

Local aItensNew		:= {}
Local aItensDiff	:= {}
Local lExistSaldo	:= .T.
Local lValorOK		:= .T.
Local nSaldoProd

Local nI, nY , nX , nT, nCase
Local aArea		:= GetArea()
Local cQuery	:= ""             
Local lAuto, nDifVlr
Local cInfAdic	:= ""
Local nToleranc		:= 0	//| Tolerancia Valor Unitarios
                      
Local oDanfe
Local nF1FORNECE, nF1LOJA , nF1DOC, nF1TIPO            
Local nD1COD, nD1CF, nD1QUANT, nD1PEDIDO, nD1ITEMPC     
Local nD1IPI, nD1VALIPI, nD1BASEIPI, nD1PICM, nD1VALICM,  nD1BASEICM
Local cCase, nPosPed, nPosItem

Local cCFBYPASS		:= ALLTRIM(U_CP01005G("11", "CFBYPAS"))
Local cForByPas 	:= ALLTRIM(U_CP01005G("11", "FORBYPAS"))

Local lNFxPC		:= U_CP01005G("11", "NFXPC")		//| Vincula NFe x Pedido Compra, (1=Nao; 2=Opcional; 3=Obrigatorio)
Local nNFxPCModo	:= U_CP01005G("11", "NFXPCMODO") 	//| Metodo utilizado para amarracao (1=Automatico (Pedidos mais antigos); 2=Informado pelo usuario)
Local lNFxPCQtde	:= U_CP01005G("11", "NFXPCQTDE")	//| Valida Quantidade ? .T. = Valida; .F. = Nao valida                                                                                                    
Local lNFxPCVlr		:= U_CP01005G("11", "NFXPCVLR") 	//| Valida Valor ? .T. = Valida; .F. = Nao valida
Local lPVxCteVl		:= U_CP01005G("11", "PVXCTEVL") 	//| Se obriga o vinculo da Nota com pedido de compra pelo valor unitario .T. ou .F.                                                                                 

Local aCFBYPASS, aForByPas                               
Local aPCSel 		:= 0
Local cPCSel		:= ""
Local lShowSelPC	:= .T.
Local aDadosa5		:= {}
Local lPcProdForn 	:= U_CP01005G("11", "PEDPXF")//|Cadastro de Produto X Fornecedor com base no Ped. Compra
Local lTesTransf  	:= .F. //| Se trata Numera��o de documento fiscal com base na TES de transferencia. F4_TRANFIL  = '1'
Local cNumNFe6    		 //| Se trata Numera��o de documento fiscal com base na TES de transferencia. F4_TRANFIL  = '1'
Local lMsgVlrDiff	:= .T.


Default lAuto		:= .F.
                                        
//����������������������������������������Ŀ
//� FORNECEDOR BY PASS no Pedido de Compra �                         
//������������������������������������������
If !EMPTY(cForByPas) 
	aForByPas := U_cpC2A(cForByPas, "/")
EndIf

//����������������������������������������������Ŀ
//� Clientes QUE NAO ASSOCIA O PEDIDO AUTOMATICO �
//������������������������������������������������
If !EMPTY(cCFBYPASS) 
	aCFBYPASS := U_cpC2A(cCFBYPASS, "/")
EndIf
 
IF LEN(aCabecNF) > 0 .AND. LEN(aItensNF) > 0

	aItens	:= aclone(aItensNF)
	
	//���������������������������������Ŀ
	//� Busca pocicionamento dos Campos �
	//�����������������������������������
	nF1DOC		:= aScan(aCabecNF,{|x| ALLTRIM(x[1])=="F1_DOC"})   //| Thiago Nascimento - 21/03/2014
	nF1SERIE	:= aScan(aCabecNF,{|x| ALLTRIM(x[1])=="F1_SERIE"}) //| Thiago Nascimento - 21/03/2014
	nF1TIPO		:= aScan(aCabecNF,{|x| ALLTRIM(x[1])=="F1_TIPO"})  //| Thiago Nascimento - 21/03/2014
	nF1FORNECE	:= aScan(aCabecNF,{|x| ALLTRIM(x[1])=="F1_FORNECE"})
	nF1LOJA		:= aScan(aCabecNF,{|x| ALLTRIM(x[1])=="F1_LOJA"})
	

	If Select("TPED") > 0
		TPED->(DbCloseArea())
	EndIf

	//���������������������������������������������������Ŀ
	//� Verificas o Fornecedor possui pedidos com Saldo e �
	//� gera novo array                                   �
	//�����������������������������������������������������
	FOR nI := 1 TO LEN(aItens)   
	
		nSaldoProd	:= 0                                               
				
		nD1COD		:= aScan(aItens[nI],{|x| ALLTRIM(x[1])=="D1_COD"})
		nD1CF		:= aScan(aItens[nI],{|x| ALLTRIM(x[1])=="D1_CF"})		
		nD1QUANT	:= aScan(aItens[nI],{|x| ALLTRIM(x[1])=="D1_QUANT"})
		nD1VUNIT	:= aScan(aItens[nI],{|x| ALLTRIM(x[1])=="D1_VUNIT"})	
		nD1TOTAL	:= aScan(aItens[nI],{|x| ALLTRIM(x[1])=="D1_TOTAL"})	
		
		nD1PEDIDO	:= aScan(aItens[nI],{|x| ALLTRIM(x[1])=="D1_PEDIDO"})		
		nD1ITEMPC	:= aScan(aItens[nI],{|x| ALLTRIM(x[1])=="D1_ITEMPC"})			
		                                                                  
		
		nD1PICM		:= aScan(aItens[nI],{|x| ALLTRIM(x[1])=="D1_PICM"})
		nD1VALICM	:= aScan(aItens[nI],{|x| ALLTRIM(x[1])=="D1_VALICM"})
		nD1BASEICM	:= aScan(aItens[nI],{|x| ALLTRIM(x[1])=="D1_BASEICM"})
		
		nD1IPI		:= aScan(aItens[nI],{|x| ALLTRIM(x[1])=="D1_IPI"})
		nD1VALIPI 	:= aScan(aItens[nI],{|x| ALLTRIM(x[1])=="D1_VALIPI"})		
		nD1BASEIPI 	:= aScan(aItens[nI],{|x| ALLTRIM(x[1])=="D1_BASEIPI"})	  
		nPOSIPI 	:= aScan(aItens[nI],{|x| ALLTRIM(x[1])=="D1_POSIPI"})	  
		            
		
		//������������������������������������������������������Ŀ
		//� Verifica se o Item da NF deve ser amarrado com o PC. �
		//� Validacao atraves do CFOP                            �
		//��������������������������������������������������������
		IF ASCAN(aCFBYPASS, RIGHT(ALLTRIM(aItens[nI,nD1CF,2]),3) ) > 0 .OR.;
			ASCAN(aForByPas, aCabecNF[nF1FORNECE,2]+aCabecNF[nF1LOJA,2] ) > 0 .OR.;
			!(lNFxPC)
			
			AADD(aItensNew, aclone(aItens[nI]) )
			
			aRet	:= {.T., "", nil, nil}
		ELSE      
		       
		
			//��������������������������������������Ŀ
			//�Metodo utilizado para amarracao       �
			//�1=Automatico (Pedidos mais antigos);  �
			//�2=Informado pelo usuario              �
			//����������������������������������������
			IF nNFxPCModo == 2 .AND. lShowSelPC
				lShowSelPC	:= .F.
							
				aAreaAux	:= GetArea()
				
				IF !lPcProdForn		//Cadastro de Produto X Fornecedor com base no Ped. Compra
					//�������������������������������������������������������������Ŀ
					//� Interface para selecao do Ped. Compra com o Danfe Importada �
					//���������������������������������������������������������������
					aPCSel	:= U_CP01006(aCabecNF, aItensNF,aPosIpiAux)  
						
					RestArea(aAreaAux)
					
					IF LEN(aPCSel) == 0
						cPCSel	:= "AND SC7.R_E_C_N_O_ = 0 "
					ELSE                                    
						cPCSel	:= "AND SC7.R_E_C_N_O_ IN "+U_cpINQry(aPCSel)
					ENDIF
					
					IF EMPTY(aPCSel)
						//aRet	:= {.f., "Pedido de Compra n�o informado pelo usu�rio.", nil, nil}
						//substiut�da linha acima pela abaixo [Mauro Nagata, wwww.compila.com.br, 20200303]
						aRet	:= {.f., "Pedido de Compras n�o informado pelo usu�rio.", nil, nil}
						RETURN(aRet)
					ENDIF					
				ELSE
					//�������������������������������������������������������������Ŀ
					//� Tratativa para vinculo de Pedido na interface de importacao �
					//� XML                                                         �
					//���������������������������������������������������������������]
					//cPCSel	:= "AND SC7.R_E_C_N_O_ IN "+U_cpINQry(aRecSC7)
					//substitu�do linha acima pelo bloco abaixo [Mauro Nagata, Compila, 20200212]
					If Len(aRecSC7) > 0
						cPCSel	:= "AND SC7.R_E_C_N_O_ IN "+U_cpINQry(aRecSC7)
					//inclu�do bloco abaixo [Mauro Nagata, Compila, 20200213]
					Else
						//�������������������������������������������������������������Ŀ
						//� Interface para selecao do Ped. Compra com o Danfe Importada �
						//���������������������������������������������������������������
						aPCSel	:= U_CP01006(aCabecNF, aItensNF,aPosIpiAux)  
							
						RestArea(aAreaAux)
						
						If Len(aPCSel) == 0
							cPCSel	:= "AND SC7.R_E_C_N_O_ = 0 "
						Else                                    
							cPCSel	:= "AND SC7.R_E_C_N_O_ IN "+U_cpINQry(aPCSel)
						EndIf
						
						
						IF EMPTY(aPCSel)
							//aRet	:= {.f., "Pedido de Compra n�o informado pelo usuario.", nil, nil}
							//substitu�da linha acima pelo abaixo [Mauro Nagata, www.compila.com.br, 20200303]
							aRet	:= {.f., "Pedido de Compras n�o informado pelo usu�rio.", nil, nil}
							RETURN(aRet)
						ENDIF						
					//fim bloco [Mauro Nagata, Compila, 20200213]	
					EndIf
					//fim bloco [Mauro Nagata, Compila, 20200212]
				ENDIF	
				

			ENDIF		

			//������������������������������������������������������������Ŀ
			//� Monta case (quando necessario) para notas que utilizam     �
			//� dois produtos iguais porem devem consumir saldo de pedidos �
			//� diferentes quando o primeiro nao possui saldo suficiente   �
			//��������������������������������������������������������������
			cCase	:= ""
			IF LEN(aItensNew) > 0                   
				//��������������������������������������Ŀ
				//� Verifica se produto ja foi utilizado �
				//����������������������������������������
				FOR nY := 1 TO LEN(aItensNew)

					nPosPed		:= aScan(aItensNew[nY],{|x| ALLTRIM(x[1])=="D1_PEDIDO"})
					nPosItem	:= aScan(aItensNew[nY],{|x| ALLTRIM(x[1])=="D1_ITEMPC"})					

					IF aItens[nI, nD1COD, 2] == aItensNew[nY, nD1COD, 2] .AND. nPosPed > 0 .AND. nPosItem > 0
										
						//��������������������������������������������������������������Ŀ
						//� Caso pedido + Item ja esteja utilizado, soma quantidades para�
						//�abater do saldo do pedido                                     �
						//����������������������������������������������������������������
						nQtdeCase	:= 0					
						FOR nCase := 1 TO LEN(aItensNew) 
						
							nPosPed2	:= aScan(aItensNew[nCase],{|x| ALLTRIM(x[1])=="D1_PEDIDO"})
							nPosItem2	:= aScan(aItensNew[nCase],{|x| ALLTRIM(x[1])=="D1_ITEMPC"})
							
							IF nPosPed2 > 0 .AND. nPosItem2 > 0
												
								IF aItensNew[nCase, nPosPed2,2] == aItensNew[nY, nPosPed,2] .and.;
									 aItensNew[nCase, nPosItem2,2] == aItensNew[nY, nPosItem,2] 
									 
									nQtdeCase	+= aItensNew[nCase, nD1QUANT,2]
								ENDIF 	
							ENDIF
						Next nCase    					
					
						IF nQtdeCase > 0
							cCase	+= " WHEN C7_NUM  = '"+aItensNew[nY, nPosPed,2]+"' AND C7_ITEM = '"+aItensNew[nY, nPosItem,2]+"' THEN (C7_QUANT-C7_QUJE-C7_QTDACLA)-"+Alltrim(str(nQtdeCase))+" "
						ENDIF
					ENDIF
				NEXT nY
				IF !EMPTY(cCase)
					cCase	:= "CASE "+cCase+" ELSE (C7_QUANT-C7_QUJE-C7_QTDACLA) END AS QTD_DISP, "
				ENDIF
			ENDIF
            
			                  
			cQuery	:= " SELECT C7_NUM, "
			cQuery	+= " 		C7_ITEM, "    
			IF EMPTY(cCase)
				cQuery	+= " 	(C7_QUANT-C7_QUJE-C7_QTDACLA) AS QTD_DISP, "
			ELSE 
				cQuery	+= cCase
			ENDIF
			cQuery	+= " 		C7_PRECO "			
			cQuery	+= " FROM "+RetSqlName("SC7")+" SC7 "

			cQuery	+= " WHERE 	C7_FILIAL = '"+XFILIAL("SC7")+"' "
			cQuery	+= " 		AND C7_FORNECE 	= '"+aCabecNF[nF1FORNECE,2]+"' "
			cQuery	+= " 		AND C7_LOJA 	= '"+aCabecNF[nF1LOJA,2]+"' "
			cQuery	+= " 		AND C7_PRODUTO 	= '"+aItens[nI, nD1COD, 2]+"' "				
			cQuery	+= " 		AND (C7_QUANT-C7_QUJE-C7_QTDACLA) > 0 "
			cQuery	+= " 		AND SC7.D_E_L_E_T_ = '' "     
			cQuery	+= " 		AND C7_CONAPRO	= 'L' "	//| Liberado
			cQuery	+= " 		AND C7_RESIDUO 	<> 'S' "     
			cQuery	+= " 		AND C7_ENCER 	<> 'E' "
			   
			//��������������������������������������Ŀ
			//�Metodo utilizado para amarracao       �
			//�1=Automatico (Pedidos mais antigos);  �
			//�2=Informado pelo usuario              �
			//�lPVxCteVl == .T. busca o pedido       �
			//�exatamente com o valor igual ao XML   �
			// Thiago Nascimento - 22/01/2014		 �
			//����������������������������������������
			IF nNFxPCModo == 1  .AND. lPVxCteVl   
				// a nota de CTE � item �nico, por isso � possivel validar valor
				cQuery += " AND C7_PRECO = '"+ cValToChar(aItens[nI, nD1VUNIT , 2]) + "' "
			ENDIF
			
			
			//��������������������������������������Ŀ
			//�Metodo utilizado para amarracao       �
			//�1=Automatico (Pedidos mais antigos);  �
			//�2=Informado pelo usuario              �
			//����������������������������������������
			IF nNFxPCModo == 2
				cQuery	+= cPCSel
			ENDIF  

			cQuery	+= " ORDER BY C7_EMISSAO, C7_NUM, C7_ITEM "     			                          
			
			cQuery	:= changeQuery(cQuery)
			DBUseArea(.T.,"TOPCONN", TCGenQry(,,cQuery),"TPED", .F., .T.)		
		
			//�����������������������������������������������Ŀ
			//� Desconsidera pedidos com saldos ja consumidos �
			//�������������������������������������������������
			WHILE TPED->(!EOF()) .AND. TPED->QTD_DISP <= 0			                                              
				TPED->(DBSKIP())
			ENDDO

			IF TPED->(!EOF())  
	
				//����������������������������������Ŀ
				//� Possui Saldo                     �
				//������������������������������������
				IF TPED->QTD_DISP >= aItens[nI, nD1QUANT, 2]
					
					AADD(aItensNew, aclone(aItens[nI]) )
					
					//����������������������Ŀ
					//� Amarra Pedido a Nota �
					//������������������������
					IF nD1PEDIDO == 0  
						AADD( aItensNew[LEN(aItensNew)], {"D1_PEDIDO", TPED->C7_NUM,NIL} ) 
					ELSE 
						aItensNew[LEN(aItensNew),nD1PEDIDO, 2]	:= TPED->C7_NUM
					ENDIF                                                      
					
					IF nD1ITEMPC == 0
						AADD( aItensNew[LEN(aItensNew)], {"D1_ITEMPC", TPED->C7_ITEM,NIL} )
					ELSE
						aItensNew[LEN(aItensNew),nD1ITEMPC, 2]	:= TPED->C7_ITEM					
					ENDIF

					//��������������������������������������������Ŀ
					//� Confronta Valor da Nota X Pedido de Compra �
					//����������������������������������������������   
					nDifVlr	:= TPED->C7_PRECO - aItens[nI, nD1VUNIT, 2]
					IF lNFxPC .AND. lNFxPCVlr
						//IF nDifVlr > nToleranc .OR. nDifVlr < (nToleranc * -1);
						IF nDifVlr <> 0
							
							
							/*------------------------------------------------------ Augusto Ribeiro | 19/02/2020 - 9:34:49 AM
								Especifico Gomes da Costa
							------------------------------------------------------------------------------------------*/
							/*
							IF nDifVlr < 0
								lMsgVlrDiff	:= .F.
							ENDIF
	                                                                              
							lValorOK	:= .F.
							//aRet[2]		+= "Divergencia de Valores entre PC x NF.: Prod.: "+alltrim(aItens[nI, nD1COD, 2])+CRLF
							//substitu�da linha acima pela abaixo [Mauro Nagata, www.compila.com.br, 20200302]
							aRet[2]		+= CRLF + "Diverg�ncia de Valores entre PC x NF. do Prod.: "+AllTrim(aItens[nI, nD1COD, 2]) + CRLF
							//aRet[2]		+= "Vlr.PC.: "+AllTrim(str(TPED->C7_PRECO)) + "        Vlr.NF.:"+AllTrim(str(aItens[nI, nD1VUNIT, 2]))+"  Dif.: "+AllTrim(Str(nDifVlr))+CRLF+CRLF
							//substitu�da linha acima pela abaixo [Mauro Nagata, www.compila.com.br, 20200303]
							aRet[2]		+= "Vlr.PC.: "+Transform(TPED->C7_PRECO,"@E 999,999,999.99") + "        Vlr.NF.:" + Transform(aItens[nI, nD1VUNIT, 2],"@E 999,999,999.99")+"  Dif.: " + Transform(nDifVlr,"@E 999,999,999.99")+CRLF+CRLF
							*/
							//substitu�do bloco acima pelao abaixo [Mauro Nagata, www.compila.com.br, 20200303]
							If nDifVlr > 0
								lMsgVlrDiff	:= .F.
							Else
								lValorOK	:= .F.
								aRet[2]		+= CRLF + "Diverg�ncia de Valores entre PC x NF. do Prod.: "+AllTrim(aItens[nI, nD1COD, 2]) + CRLF
								aRet[2]		+= "   Vlr.PC.: "+Transform(TPED->C7_PRECO,"@E 999,999,999.99") + "        Vlr.NF.:" + Transform(aItens[nI, nD1VUNIT, 2],"@E 999,999,999.99")+"     Dif.: " + Transform(nDifVlr,"@E 999,999,999.99")+CRLF+CRLF
							EndIf
							//fim bloco [Mauro Nagata, www.compila.com.br, 20200303]
					
						//ENDIF
						ENDIF
					ENDIF

	
				//����������������������������������������������������������������Ŀ
				//�Verifica se existem outros pedidos que possuam Saldo suficiente �
				//������������������������������������������������������������������
				ELSE
					
	
					//������������������������������������������������������Ŀ
					//� Array com os registros para compensar as diferencas  �
					//� Caso a liberacao seja realizada de forma manual      �
					//��������������������������������������������������������
					AADD(aItensDiff, aclone(aItens[nI]) )					
					
					WHILE TPED->(!EOF()) 
					
						//�����������������������������������������������Ŀ
						//� Desconsidera pedidos com saldos ja consumidos �
						//�������������������������������������������������
						IF TPED->QTD_DISP <= 0
							TPED->(DBSKIP())
							LOOP
						ENDIF
						       
						
						//��������������������������������������������Ŀ
						//� Confronta Valor da Nota X Pedido de Compra �
						//����������������������������������������������
						IF lNFxPC .AND. lNFxPCVlr
							nDifVlr	:= TPED->C7_PRECO - aItens[nI, nD1VUNIT, 2]
							//IF nDifVlr > nToleranc .OR. nDifVlr < (nToleranc * -1);
							IF nDifVlr <> 0
								/*------------------------------------------------------ Augusto Ribeiro | 19/02/2020 - 9:34:49 AM
									Especifico Gomes da Costa
								------------------------------------------------------------------------------------------*/
								/*
								IF nDifVlr < 0
									lMsgVlrDiff	:= .F.
								ENDIF
		                                                                              
								//lValorOK	:= .F.
								//aRet[2]		+= "Valores| Prod.: "+aItens[nI, nD1COD, 2]+" Dif.: "+ALLTRIM(STR(nDifVlr))+EOL
								lValorOK	:= .F.
								aRet[2]		+= "Divergencia de Valores entre PC x NF: Prod.: "+alltrim(aItens[nI, nD1COD, 2])+CRLF
								aRet[2]		+= "Vlr. PC.: "+alltrim(str(TPED->C7_PRECO))+"   Vlr. NF.:"+alltrim(str(aItens[nI, nD1VUNIT, 2]))+"  Dif.: "+ALLTRIM(STR(nDifVlr))+CRLF+CRLF
								*/
								//substitu�do bloco acima pelao abaixo [Mauro Nagata, www.compila.com.br, 20200303]
								If nDifVlr > 0
									lMsgVlrDiff	:= .F.
								Else
									lValorOK	:= .F.
									aRet[2]		+= CRLF + "Diverg�ncia de Valores entre PC x NF. do Prod.: "+AllTrim(aItens[nI, nD1COD, 2]) + CRLF
									aRet[2]		+= "   Vlr.PC.: "+Transform(TPED->C7_PRECO,"@E 999,999,999.99") + "        Vlr.NF.:" + Transform(aItens[nI, nD1VUNIT, 2],"@E 999,999,999.99")+"      Dif.: " + Transform(nDifVlr,"@E 999,999,999.99")+CRLF+CRLF
								EndIf
								//fim bloco [Mauro Nagata, www.compila.com.br, 20200303]
															
							ENDIF		
						ENDIF
						     
						
						//��������������������������������������������������������������������Ŀ
						//� Verifica e realiza tratamento caso tenha atingido saldo necessario �
						//����������������������������������������������������������������������
						IF (TPED->QTD_DISP+nSaldoProd) < aItens[nI, nD1QUANT, 2]
							nQtdDisp	:= TPED->QTD_DISP
						ELSE
							nQtdDisp	:= (aItens[nI, nD1QUANT, 2]-nSaldoProd)
						ENDIF  
	
						nSaldoProd	+= nQtdDisp					
																
						AADD(aItensNew, aclone(aItens[nI]) )
						  
						//����������������������������������������������
						//� Realiza acerto na quantidade e valor total �
						//����������������������������������������������
						aItensNew[LEN(aItensNew),nD1QUANT, 2]	:= nQtdDisp
						aItensNew[LEN(aItensNew),nD1TOTAL, 2]	:= (nQtdDisp*aItens[nI, nD1VUNIT, 2])
	
											                               
						//������Ŀ
						//� ICMS �
						//��������
						IF nD1VALICM > 0
							IF aItensNew[LEN(aItensNew),nD1VALICM, 2] > 0
								IF nD1PICM > 0 .AND. nD1BASEICM > 0
									aItensNew[LEN(aItensNew),nD1BASEICM, 2]		:= (aItens[nI, nD1BASEICM, 2] / aItens[nI, nD1QUANT, 2]) * aItensNew[LEN(aItensNew),nD1QUANT, 2]
									aItensNew[LEN(aItensNew),nD1VALICM, 2]		:= (aItensNew[LEN(aItensNew),nD1BASEICM, 2]*aItensNew[LEN(aItensNew),nD1PICM, 2])/100
								ELSE                                                                                                                              
									aItensNew[LEN(aItensNew),nD1BASEICM, 2]	:= 0
									aItensNew[LEN(aItensNew),nD1VALICM, 2]	:= 0								
								ENDIF
							ENDIF
						ENDIF                                                       
						
						//�����Ŀ
						//� IPI �
						//�������
						IF nD1VALIPI > 0
							IF aItensNew[LEN(aItensNew),nD1VALIPI, 2] > 0
								IF nD1IPI > 0 .AND. nD1BASEIPI > 0   
									aItensNew[LEN(aItensNew),nD1BASEIPI, 2]		:= (aItens[nI, nD1BASEIPI, 2] / aItens[nI, nD1QUANT, 2]) * aItensNew[LEN(aItensNew),nD1QUANT, 2]							
									aItensNew[LEN(aItensNew),nD1VALIPI, 2]		:= 	(aItensNew[LEN(aItensNew),nD1BASEIPI, 2]*aItensNew[LEN(aItensNew),nD1IPI, 2])/100
								ELSE                                   
									aItensNew[LEN(aItensNew),nD1BASEIPI, 2]	:= 0
									aItensNew[LEN(aItensNew),nD1VALIPI, 2]	:=	0
								ENDIF
							ENDIF
						ENDIF
	
	
	
						//������������������������������Ŀ
						//� Adiciona no array diferencas �
						//��������������������������������
						aItensDiff[LEN(aItensDiff),nD1QUANT, 2]	-= nQtdDisp
						aItensDiff[LEN(aItensDiff),nD1TOTAL, 2]	:= (aItensDiff[LEN(aItensDiff),nD1QUANT, 2]*aItens[nI, nD1VUNIT, 2])					
						IF nD1VALICM > 0 .AND. nD1BASEICM > 0
							aItensDiff[LEN(aItensDiff),nD1BASEICM, 2]	-= 	aItensNew[LEN(aItensNew),nD1BASEICM, 2]
							aItensDiff[LEN(aItensDiff),nD1VALICM, 2]	-=	aItensNew[LEN(aItensNew),nD1VALICM, 2]
						ENDIF					
						IF nD1VALIPI > 0 .AND. nD1BASEIPI > 0
							aItensDiff[LEN(aItensDiff),nD1BASEIPI, 2]	-= 	aItensNew[LEN(aItensNew),nD1BASEIPI, 2]
							aItensDiff[LEN(aItensDiff),nD1VALIPI, 2]	-=	aItensNew[LEN(aItensNew),nD1VALIPI, 2]
						ENDIF					
						
	
						//����������������������Ŀ
						//� Amarra Pedido a Nota �
						//������������������������						
						IF nD1PEDIDO == 0  
							AADD(aItensNew[LEN(aItensNew)], {"D1_PEDIDO"		, TPED->C7_NUM,NIL}) 
						ELSE 
							aItensNew[LEN(aItensNew),nD1PEDIDO, 2]	:= TPED->C7_NUM
						ENDIF                                                      
						
						IF nD1ITEMPC == 0
							AADD(aItensNew[LEN(aItensNew)], {"D1_ITEMPC"		, TPED->C7_ITEM,NIL})
						ELSE
							aItensNew[LEN(aItensNew),nD1ITEMPC, 2]	:= TPED->C7_ITEM
						ENDIF					
					                                  
						IF nSaldoProd >= aItens[nI, nD1QUANT, 2]
						    EXIT
						ENDIF
						TPED->(DBSKIP())
					ENDDO
					                     
					//����������������������������
					//� Verifica se existe saldo �
					//����������������������������
					IF nSaldoProd >= aItens[nI, nD1QUANT, 2]
					    lExistSaldo	:= .T.
					ELSE 
						lExistSaldo	:= .F.
					ENDIF
				ENDIF				
			ELSE     
			
				//������������������������������������������������������Ŀ
				//� Array com os registros para compensar as diferencas  �                                                         		
				//� Caso a liberacao seja realizada de forma manual      �
				//��������������������������������������������������������
				AADD(aItensNew, aclone(aItens[nI]) )
							
				lExistSaldo		:= .F.	
			ENDIF 
			
			TPED->(DbCloseArea())					
			SC7->(DbCloseArea())
		ENDIF
	Next nI
                 

	/*------------------------------------------------------ Augusto Ribeiro | 19/02/2020 - 9:34:49 AM
		Especifico Gomes da Costa
	
	IF lExistSaldo .AND. lNFxPCQtde .AND. !(lValorOK) .AND. lNFxPCVlr .AND. lNFxPCVlr .AND. lMsgVlrDiff
	ENDIF
	------------------------------------------------------------------------------------------*/

	
	IF lExistSaldo .AND. lValorOK
		aRet	:= {.T., "", nil, nil}
		
	ELSEIF !(lExistSaldo) .AND. lNFxPCQtde                                                                    
			//aRet[2]	+= "Saldos em Pedidos de Compra insucificente."+EOL
			//substitu�da linha acima pela abaixo [Mauro Nagata, Compila, 20200212]
			aRet[2]	+= EOL + "Saldos em Pedidos de Compra insuficiente. [1]" + EOL				
			
	ELSEIF !(lValorOK) .AND. lNFxPCVlr .AND. !(lMsgVlrDiff) //| Especifico Gomes |
	
			//aRet[2]	+= EOL + "Divergencia de Valores " + EOL	
			

	ELSE        

		IF lAuto
			aRet[1]	:= .T.
		ELSE
			
			
			//IF IIF(!lNFxPCVlr , .T. ,Aviso("Divergencia - Nota x Pedido", aRet[2]+EOL,{"Confirmar", "Cancelar"},3,"Desconsiderar divergencias ?") == 1)
			//substitu�da linha acima pela abaixo [Mauro Nagata, www.compila.com.br, 20200303]
			IF IIF(!lNFxPCVlr , .T. ,Aviso("Diverg�ncia - Nota x Pedido", aRet[2]+EOL,{"Confirmar", "Cancelar"},3,"Desconsiderar divergencias ?") == 1)
			
								
				//���������������������������������������������������������������������Ŀ
				//� Realiza tratamento para utilizar saldo dos pedidos existentes mesmo �
				//�que total do saldo nao seja suficiente                               �
				//�����������������������������������������������������������������������
				FOR nI := 1 to LEN(aItensDiff)
					IF aItensDiff[LEN(aItensDiff),nD1QUANT, 2] > 0
						aadd(aItensNew, aclone(aItensDiff[nI])) 
					ENDIF
				NEXT nI
				
				
				aRet[1]	:= .T.
				aRet[2]	+= ""							       
							        
				//aRet[1]	:= .F.
				//aRet[2]	+= " Saldos em Pedidos de Compra insucificente."
									
			ENDIF
			
		ENDIF
	ENDIF	
	
	
	//�����������������������������������������������������������������Ŀ
	//� Reordena Array para que Pedido e Item de pedido fiquem          �
	//� antes do Valor. Tratamento necess�rio para que seja considerado �
	//� o valor da nota fiscal e nao do Pedido de Compra                �
	//�������������������������������������������������������������������
	IF aRet[1]
	     
		IF LEN(aItensNew)	> 0
			aItensNF	:= {}
			FOR nI := 1 TO LEN(aItensNew)   
				
				aadd(aItensNF,{} )
		
				nD1COD		:= aScan(aItensNew[nI],{|x| ALLTRIM(x[1])=="D1_COD"})
				nD1PEDIDO	:= aScan(aItensNew[nI],{|x| ALLTRIM(x[1])=="D1_PEDIDO"})		
				nD1ITEMPC	:= aScan(aItensNew[nI],{|x| ALLTRIM(x[1])=="D1_ITEMPC"}) 


				FOR nX := 1 TO LEN(aItensNew[nI])
					                     
					IF nX == nD1PEDIDO .OR. nX == nD1ITEMPC
						LOOP
					ENDIF			
		
					AADD(aItensNF[LEN(aItensNF)], aItensNew[nI, nX])					                                                         
		
					//���������������������������������������������������Ŀ
					//� Posiciona Inf. do Pedido apos o codigo do produto �
					//�����������������������������������������������������
					IF nX == nD1COD	.AND. nD1ITEMPC+nD1ITEMPC > 0
						AADD(aItensNF[LEN(aItensNF)], aItensNew[nI, nD1PEDIDO])
						AADD(aItensNF[LEN(aItensNF)], aItensNew[nI, nD1ITEMPC])
					ENDIF				
				Next nX
				
			NEXT nI  
		ENDIF
		
	ENDIF  
ENDIF

//���������������������������������������Ŀ
//� Tratamento para notas de transf�ncia �
//�  entre filiais						 �
//����������������������������������������
/*IF ! lNFxPC	
	For nT := 1 to Len(aItens)
			
		//nD1CF		:= aScan(aItens[nI],{|x| ALLTRIM(x[1])=="D1_CF"})
		
		//��������������������������������������Ŀ
		//� Verifico se algum item possui TES    �
		//� de Transfer�ncia  entre filiais	     �
		//����������������������������������������
		DBSELECTAREA("SF4")
		SF4->(DBORDERNICKNAME("COMPSF401")) //| F4_FILIAL, F4_CF, R_E_C_N_O_, D_E_L_E_T_
		IF  SF4->(DbSeek(XFILIAL("SF4")+ "1" + RIGHT(aItens[nT,nD1CF,2],3)))
			IF SF4->F4_TRANFIL == "1"
	 			lTesTransf := .T.
	 			EXIT
	 		ENDIF	
		ENDIF
		
	Next nT
	
	//����������������������������������������Ŀ
	//� Ap�s Varrer os itens da Nota, caso     �
	//� alguma TES seja de trasf�rencia inicio �
	//� tratamento de 9 ou 6 caracteres para   �	
	//� Execauto						       �
	//������������������������������������������
	IF lTesTransf
		
		//�����������������������������������������������������������������������Ŀ
		//� TratTransf RETORNO {numero da nota , l�gico(se achou CNPJ no SIGAMAT)} �
		//�������������������������������������������������������������������������
		aTranfFil := TratTransf( aCabecNF[nF1FORNECE,2], aCabecNF[nF1LOJA,2] , aCabecNF[nF1DOC,2] ,aCabecNF[nF1SERIE,2], aCabecNF[nF1TIPO,2] )
		
		//�����������������������������������������Ŀ
		//� Caso tenha encontrado a nota origem de  �
		//� transferencia retorna a nota com 9 ou 6 �
		//� digitos para Execauto de gera��o de pr� �
		//� nota e futura classifica��o 			�
		//�������������������������������������������
		IF aTranfFil[2]
			aRet[3] := aTranfFil[1]
			aRet[4] := .T.	
		ELSE
			aRet[3] := "Nota fiscal de origem n�o localizada em sua filial"
			aRet[4] := .F.			
		ENDIF
		
	ENDIF	        
ENDIF
*/
RestArea(aArea)
Return(aRet)


/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � TratTransf �Autor  � Thiago Nascimento� Data �  21/03/2014 ���
�������������������������������������������������������������������������͹��
���Desc.     � Tratamento da quantidade de caracteres do numero da        ���
���          � nota fiscal de transferencia entre filiais                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
Static Function TratTransf( cFornece , cLoja , cNumDoc , cNumSer , cTipoNF)

Local aTransRet := {"", .F.}
Local cCGCFIL := IIF(cTipoNF == "B",POSICIONE("SA1",1,XFILIAL("SA1")+cFornece+cLoja ,"A1_CGC"),POSICIONE("SA2",1,XFILIAL("SA2")+cFornece+cLoja ,"A2_CGC"))
Local cCodOrFil
Local aAreaSM0 
Local lFindOri := .F.

DBSELECTAREA("SM0")
aAreaSM0 := SM0->(GetArea())

SM0->(DBGOTOP())  

//�����������������������������������������������������������������Ŀ
//� Ap�s salvar ALIAS SM0, fa�o uma varredura para encontrar pelo   �
//� CNPJ o c�digo da Filial correpondente no sistema, para a seguir �
//� verificar se nota existe na filial origem com 9 ou 6 digitos    �
//�������������������������������������������������������������������		
WHILE SM0->(!EOF())        

	IF ALLTRIM(SM0->M0_CGC) == cCGCFIL
		cCodOrFil := SM0->M0_CODFIL
		lFindOri := .T.
		EXIT	
	ENDIF
	SM0->(DBSKIP())
	
ENDDO

IF lFindOri
	
	DBSELECTAREA("SF2")
	SF2->(DBSETORDER(1)) 
	
	//����������������������������������������Ŀ
	//� Busco a nota origem na filial emitente �
	//� com 9 digitos, caso ache utilizo 9     �
	//�����������������������������������������
	IF SF2->(DBSEEK( cCodOrFil + cNumDoc + cNumSer ))
		
		// Retorno o encontrado para lan�ar documento de entrada de transf�ncia
		aTransRet[1] := cNumDoc
		aTransRet[2] := .T.
	ELSE
		
		cNumNFe6	:= ALLTRIM(STR(VAL(cNumDoc)))
								
		IF LEN(cNumNFe6) <= 6                                 
			cNumNFe6	:= STRZERO(VAL(cNumDoc),6)
			cNumNFe6	:= PADR(cNumNFe6, TAMSX3("F2_DOC")[1]," ")
			
			IF SF2->(DBSEEK( cCodOrFil + cNumNFe6 + cNumSer ))
				
				// Retorno o encontrado para lan�ar documento de entrada de transf�ncia			
				aTransRet[1] := cNumNFe6  
				aTransRet[2] := .T.
				
			ELSE
				
				aTransRet[1] := "Nota fiscal de origem n�o encontrada na filial: "+ cCodOrFil + ", CNPJ: "+ cCGCFIL 
				
			
			ENDIF
			
		ENDIF
	
	ENDIF


//����������������������������������������Ŀ
//� Retorno .F. caso CNPJ nao corresponda �
//� a uma filial de origem so SIGAMAT     �
//�����������������������������������������
ELSE

	aTransRet[1] := "CNPJ: "+ cCGCFIL + "n�o localizado como filial de origem"
	
ENDIF	

RestArea(aAreaSM0)
Return(aTransRet)