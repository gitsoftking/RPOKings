#Include "Protheus.Ch"
#Include "Rwmake.Ch" 
#INCLUDE 'TopCONN.CH'
#INCLUDE 'TBICONN.CH'

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � CP0108E  �Autor  �Augusto Ribeiro     � Data � 04/04/2012  ���
�������������������������������������������������������������������������͹��
���Desc.     � Classificacao automatica da Pre-Nota                       ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �      	                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
User Function CP0108E(cDoc, cSerie, cFor, cLoja)
Local aRet := {.F., ""}
Local aCabec                   	
Local aLinha
Local aItens, cTES     
Local lClassifica	:= .T.

Local nCpoSF1	:= SF1->(FCOUNT())
Local nCpoSD1	:= SD1->(FCOUNT())
Local nF1COND
Local nI, nY, nTotReg   
Local nD1NFORI, nD1NFSERIORI, nD1NFITEMORI
Local lVincOrig		:= .F.//U_CP01005G("11", "VINCORIG") //|Se vincula origem na nota de entrada de remessa, .T. .OR. .F.
Local nInc 			:= 1

Private lTitNFeAuto	:= .F. //| Variavel utilizada no P.E. MTCOLSE2 para grava��o customizada dos titulos
                     

IF !EMPTY(cDoc) .AND.;
	!EMPTY(cFor) .AND.;
	!EMPTY(cLoja)     
	
                                                                                     
	DBSELECTAREA("SA2") 
	SA2->(DBSETORDER(1))
	
	DBSELECTAREA("SB1") 
	SB1->(DBSETORDER(1))	
 
	DBSELECTAREA("SF1") 
	SF1->(DBSETORDER(1))//| F1_FILIAL, F1_DOC, F1_SERIE, F1_FORNECE, F1_LOJA, F1_TIPO
	IF SF1->(DBSEEK(XFILIAL("SF1") + cDoc + cSerie + cFor + cLoja))
	
		
		DBSELECTAREA("SD1") 		
		SD1->(DBSETORDER(3))//| D1_FILIAL, DTOS(SD1->D1_EMISSAO),D1_DOC, D1_SERIE, D1_FORNECE, D1_LOJA
		IF SD1->( DBSEEK(SF1->F1_FILIAL+DTOS(SF1->F1_EMISSAO)+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA) )
		//SD1->( DBSEEK(SF1->(F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA)) )//D1_FILIAL, D1_DOC, D1_SERIE, D1_FORNECE, D1_LOJA, D1_COD, D1_ITEM, R_E_C_N_O_, D_E_L_E_T_
			
			aCabec	:= {}
			aLinha	:= {}
			aItens	:= {}
			           
			//������������������������������
			//� Alimenta CABECALHO da Nota �
			//������������������������������ 
			DBSELECTAREA("SF1") 
			FOR nI := 1 to nCpoSF1	 
				IF ALLTRIM(SF1->(FieldName(nI))) == "F1_COND"
					nF1COND	:= nI	//AADD(aCabec,{FieldName(nI), "001", nil })
				ENDIF							
				
				IF !EMPTY(FieldGet(nI))	 .OR. nF1COND > 0
					AADD(aCabec,{SF1->(FieldName(nI)), SF1->(FieldGet(nI)), nil })			
				ENDIF
			NEXT nI                                                             

		                               
			nTotReg := CountItens( SF1->F1_FILIAL, SF1->F1_DOC, SF1->F1_SERIE, SF1->F1_FORNECE, SF1->F1_LOJA )
			PROCREGUA(nTotReg)
					
			WHILE SD1->(!EOF()) .AND. SF1->(F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA) == SD1->(D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA)
				
				INCPROC("Classificando DANFE... "+cValtoChar(Round((nInc/nTotReg*100),0))+ "%")
				
				//���������������������������������������������������������������������Ŀ
				//� Valida se existe algum item sem o codigo do Item do XML.            �
				//� Necessario abortar a importacao pois caso o filtro seja utilizado a �
				//�tabela Z11 (Itens do XML) a validacao sera realizada sobre um        �
				//�registro incorreto.                                                  �
				//�����������������������������������������������������������������������
				IF EMPTY(SD1->D1_XITEXML)
					lClassifica	:= .F. 
					aRet[2] := "O  Item D1_ITEM n�o foi gerado via importacao. Classificacao automatica cancelada."
					EXIT					
				ENDIF
			
			                 
				DBSELECTAREA("SD1")
				aLinha	:= {}
				//������������������������������
				//� Alimenta ITENS da Nota     �
				//������������������������������
				FOR nI := 1 to nCpoSD1	  
	
					IF ALLTRIM(SD1->(FieldName(nI))) == "D1_TES" .AND. ! lVincOrig .AND. EMPTY(SD1->D1_NFORI) // Quando vincula nf de origem n�o utilizamos configurador de TES
						aChave	:= {SD1->D1_DOC, SD1->D1_SERIE, SD1->D1_FORNECE, SD1->D1_LOJA, SD1->D1_COD, SD1->D1_ITEM}
	                                                    
						cTES	:= U_CP01009T("E", , aChave)     

						/*----------------------------------------
							19/07/2019 - Jonatas Oliveira - Compila
							Ponto de entrada para atribui��o de TES
						------------------------------------------*/
						IF EXISTBLOCK("CP0102TS")
							cTES	:= U_CP0102TS(@cTES)
						ENDIF
												
						AADD(aLinha,{SD1->(FieldName(nI)), cTES , nil })
						
						//������������������������������������Ŀ
						//� Verifica se a TES Gera - DUPLICATA �
						//��������������������������������������
						DBSELECTAREA("SF4")
						SF4->(DBSETORDER(1))   //| F4_FILIAL, F4_CODIGO

						IF SF4->(DBSEEK(XFILIAL("SF4") + cTES))
							IF SF4->F4_DUPLIC == "S"
								lTitNFeAuto	:= .T.
							ENDIF
							
						ENDIF
					ELSEIF ALLTRIM(SD1->(FieldName(nI))) == "D1_CF" .AND. !EMPTY(cTES) .AND. EMPTY(SD1->( FieldGet( nI ) ) )
						IF SF4->F4_CODIGO == cTES
							AADD(aLinha,{SD1->(FieldName(nI)), SF4->F4_CF , nil })
						ELSE
							IF SF4->(DBSEEK(XFILIAL("SF4") + cTES))
								AADD(aLinha,{SD1->(FieldName(nI)), SF4->F4_CF , nil })
							ENDIF 								
						ENDIF 
					ELSE
						IF !EMPTY(SD1->(FieldGet(nI)))		
							AADD(aLinha,{SD1->(FieldName(nI)), SD1->(FieldGet(nI)), nil })								
						ENDIF
					ENDIF

				NEXT nI	 
				
									
//				AADD(aLinha,{"D1_PEDIDO", "", nil })
//				AADD(aLinha,{"D1_ITEMPC", "", nil })
				
				//�������������������������������������������Ŀ
				//� Tratamento para Nota fiscal de Devolucao  �
				//��������������������������������������������� 
				IF SF1->F1_TIPO == "D"  
				
				
					dbselectarea("Z10")
					Z10->(DBSETORDER(1)) //| Z10_FILIAL, Z10_CHVNFE, Z10_TIPARQ
					IF Z10->(DBSEEK(XFILIAL("Z10")+SF1->F1_CHVNFE+"E") )
					
						IF !EMPTY(Z10->Z10_CHVREF)
				                                                                        
							nD1COD 			:= aScan(aLinha,{|x| ALLTRIM(x[1])=="D1_COD"})					
							nD1NFORI		:= aScan(aLinha,{|x| ALLTRIM(x[1])=="D1_NFORI"})	
							nD1NFSERIORI	:= aScan(aLinha,{|x| ALLTRIM(x[1])=="D1_NFSERIORI"})	
							nD1NFITEMORI	:= aScan(aLinha,{|x| ALLTRIM(x[1])=="D1_NFITEMORI"})
							
							//����������������������������������������������
							//� Busca Nota e Item para amarrar a devolucao �
							//����������������������������������������������
							
							aDanfeOrig		:= {}
							aDanfeOrig		:= U_CP01G05(Z10->Z10_CHVREF, aLinha[nD1COD,2]) 
							
							IF LEN(aDanfeOrig)
								IF nD1NFORI == 0
									AADD(aLinha,{"D1_NFORI", aDanfeOrig[1] , nil }) 
									
									IF nD1NFSERIORI == 0
										AADD(aLinha,{"D1_NFSERIORI",aDanfeOrig[2] , nil }) 						
									ELSE                
										aLinha[nD1NFSERIORI,2]	:= aDanfeOrig[2]
									ENDIF 
									
									IF nD1NFITEMORI == 0
										AADD(aLinha,{"D1_NFITEMORI", aDanfeOrig[3], nil }) 						
									ELSE
										aLinha[nD1NFITEMORI,2]	:= 	aDanfeOrig[3]					
									ENDIF					
								ENDIF 
							ENDIF
						ENDIF  
					ENDIF					
				ENDIF
				
				//���������������������������������Ŀ
				// Se For uma entrada de uma nota	� 
				// que necessite vincular origem	�
				// entra na exece��o abaixo			�
				//�����������������������������������
				IF lVincOrig
							
					//����������������������������������Ŀ
					// Retorno da User Function CP01011: � 
					// TIPO: ARRAY UNIDIMENSIONAL	 	 �
					// [1]: RETORNO L�GICO 			(L)  �
					// [2]: NOTA ORIGEM 			(C)  �
					// [3]: SERIE ORIGEM			(C)  �
					// [4]: ITEM ORIGEM				(C)  �
					// [5]: ID DO PODER DE TERCEIRO (C)  �
					// [5]: MENSAGEM DE RETORNO		(C)  �
					//������������������������������������									
					IF ! EMPTY(SD1->D1_NFORI)
						
						aRetPD3:= u_CP0101X( SD1->D1_FILIAL , SD1->D1_COD, SD1->D1_FORNECE, SD1->D1_LOJA , SD1->D1_NFORI, SD1->D1_SERIORI , SD1->D1_QUANT, SD1->D1_VUNIT )											
					
						IF aRetPD3[1]
																	 								
							AADD(aLinha, {"D1_NFORI"	,aRetPD3[2]		,NIL})
							AADD(aLinha, {"D1_SERIORI"	,aRetPD3[3]		,NIL}) 
							AADD(aLinha, {"D1_ITEMORI"	,aRetPD3[4]		,NIL})
							AADD(aLinha, {"D1_IDENTB6"	,aRetPD3[5]		,NIL})
							IF EMPTY(cTES)
								
								//������������������������������������Ŀ
								//� Verifica se a TES Gera - DUPLICATA �
								//��������������������������������������
								DBSELECTAREA("SF4")
								SF4->(DBSETORDER(1))   //| F4_FILIAL, F4_CODIGO

								IF SF4->(DBSEEK(XFILIAL("SF4")+aRetPD3[7]))
									
									IF SF4->(DBSEEK(XFILIAL("SF4")+SF4->F4_TESDV)) // BUSCO TES DE DEVOLU��O
										
										cTES := SF4->F4_CODIGO										
										AADD(aLinha, {"D1_TES"	,cTES	,NIL})			
										
										IF SF4->F4_DUPLIC == "S"
											lTitNFeAuto	:= .T.
										ENDIF
										
									ENDIF
									
								ENDIF
																												
							ENDIF			
						
							aRet[2]	+= aRetPD3[6]+CRLF
						
						ELSE
							
							lClassifica	:= .F. 
							aRet[2] += aRetPD3[6]+CRLF
												
														
						ENDIF
					
					ELSE
							
						lClassifica	:= .F. 
						aRet[2] += "Este tipo de entrada deve-se vincular o poder de terceiro Verifique."+CRLF
									
					ENDIF
				ENDIF
				
				//�����������������������������������������Ŀ
				//� Centro de custo opera��es automatizadas �
				//� Regra especifica para Zatix				�
				//�������������������������������������������
				//AADD(aLinha,{"D1_CC", GetMv("ZX_AUTCCUS") , nil })
				
				aadd(aItens, aLinha)
                
                nInc++
				SD1->(DBSKIP())
			ENDDO
			
			
               
			IF lClassifica  
			           
				//������������������������������������Ŀ
				//� Verifica se a TES Gera - DUPLICATA �
				//��������������������������������������
				IF lTitNFeAuto                                                                              
					aCabec[nF1COND,2]		:= ALLTRIM(U_CP01005G("11", "CPAGPADRAO"))
					AADD(aCabec,{"E2_NATUREZ", ALLTRIM(U_CP01005G("11", "NATPADRAO")), nil })
															
				ENDIF
			
				BEGIN TRANSACTION
				
					lMSErroAuto := .F. 
	
					nOpc	:= 4 //| Classificacao
					MSExecAuto({|x,y,z|Mata103(x,y,z)},aCabec,aItens,nOpc)   
	
					If lMSErroAuto
						DisarmTransaction()
						//MostraErro()
	
						cErroExec	:= ""
						cPathLog	:=	NOMEAUTOLOG()
						IF !EMPTY(cPathLog)
							cErroExec	:=	STRTRAN(MemoRead(cPathLog),'"',"")
							
						  	cErroExec	:= U_CPXERRO(cErroExec)
						ENDIF
						
						aRet[2]	:= "Falha na Gera��o da Pre-Nota "+CRLF+cErroExec+CRLF
					ELSE          
				
						//������������������������������Ŀ
						//� Pre-Nota Gravada com Sucesso �
						//��������������������������������
						aRet[1]	:= .T.
						aRet[2]	:= "Nota Fiscal Classificada com sucesso!"+CRLF
						
						//Tratamento para legenda caso classifica��o automatica - Thiago Nascimento - 22/01/14
						DBSELECTAREA("Z10")
						Z10->(DBSETORDER(1)) //| Z10_FILIAL, Z10_CHVNFE, Z10_TIPARQ
						IF Z10->(DBSEEK(XFILIAL("Z10")+SF1->F1_CHVNFE) )
						
							//Status 5, nota Classificada.
							Reclock("Z10", .F.)
								Z10->Z10_STATUS := "5"
							Z10->(MSUNLOCK())
							
						ENDIF
					ENDIF		     
					
				END TRANSACTION
			ENDIF
						
		ELSE                                        
			aRet[2]	:= "Pre-Nota N�o encontrada [SD1]"+CRLF			
		ENDIF
	ELSE
		aRet[2]	:= "Pre-Nota N�o encontrada [SF1]"+CRLF	
	ENDIF	                                    
ELSE
	aRet[2]	:= "Parametros em branco."+CRLF	
ENDIF

       

Return(aRet)



/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � CP0108S  �Autor  �Augusto Ribeiro     � Data � 09/05/2012  ���
�������������������������������������������������������������������������͹��
���Desc.     � Gera nota fiscal de saida automaticamente                  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �      	                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
User Function CP0108S(cNumPedido, cChvNfe)   
Local aRet := {.F., ""}
Local nPrcVen
Local cNota 	:= ""
Local cSerie	:= ""
Local cNumNFAnt	:= ""
Local aPvlNfs	:= {} 
Local lLiberPv	:= U_CP01005G("12", "XMLLBPV")	//| Gera Pre-Nota apos importadar Danfe    
Local _cPedido	:= ""

//Default lLiberPv	:= .F. // U_CP01005G("11", "XMLGPNF")	//| Gera Pre-Nota apos importadar Danfe

IF EMPTY(cNumPedido)
	cNumPedido	:= fRetPV(cChvNfe)
ENDIF
             

IF !EMPTY(cNumPedido)         

	DBSELECTAREA("SC5")
	SC5->(DBSETORDER(1))
	IF SC5->(DBSEEK(XFILIAL("SC5")+cNumPedido))
              
		DBSELECTAREA("Z10")
		Z10->(DBSETORDER(1))                       
		IF Z10->(DBSEEK(XFILIAL("Z10")+SC5->C5_XCHVNFE+"S")) .and. !EMPTY(SC5->C5_XCHVNFE)
		
		
			cSerie	:= ALLTRIM(Z10->Z10_SERIE)    
			
			DBSELECTAREA("SF2")
			SF2->(DBSETORDER(2))
			IF SF2->(!DBSEEK(XFILIAL("SF2")+Z10->Z10_NUMNFE+cSerie))

				DBSELECTAREA("SC6")
				SC6->(DBSETORDER(1))	
				IF SC6->(DBSEEK(XFILIAL("SC6")+cNumPedido))
				
					DBSELECTAREA("SC9")
					SC9->(DBSETORDER(1))

	
					DBSELECTAREA("SE4")
					SE4->(DBSETORDER(1))
					
					DBSELECTAREA("SB1")
					SB1->(DBSETORDER(1))
					
					DBSELECTAREA("SB2")
					SB2->(DBSETORDER(1))
					
					DBSELECTAREA("SF4")
					SF4->(DBSETORDER(1))
				
					WHILE SC6->(!EOF()) .AND. SC6->C6_NUM == SC5->C5_NUM  
	
						_cPedido	:= SC6->C6_NUM							
						
	                    SC9->(MsSeek(xFilial("SC9")+SC6->(C6_NUM+C6_ITEM)))    
 
						//������������������������������Ŀ
						//�Faz a Liberacao do Pedido     �
						//�Jonatas Oliveira - 26/07/2012 �
						//��������������������������������						
						IF lLiberPv //FILIAL+NUMERO+ITEM														
							MaLibDoFat(SC6->(RecNo()),SC6->C6_QTDVEN,,,.T.,.T.,.F.,.F.)                                                                                 

						ENDIF 																

						SE4->(MsSeek(xFilial("SE4")+SC5->C5_CONDPAG) )  //FILIAL+CONDICAO PAGTO				
						SB1->(MsSeek(xFilial("SB1")+SC6->C6_PRODUTO))    //FILIAL+PRODUTO				
						SB2->(MsSeek(xFilial("SB2")+SC6->(C6_PRODUTO+C6_LOCAL))) //FILIAL+PRODUTO+LOCAL				
						SF4->(MsSeek(xFilial("SF4")+SC6->C6_TES))   //FILIAL+TES
						
						nPrcVen := SC9->C9_PRCVEN
						If ( SC5->C5_MOEDA <> 1 )
							nPrcVen := xMoeda(nPrcVen,SC5->C5_MOEDA,1,dDataBase)
						EndIf
						
						Aadd(aPvlNfs,{ SC9->C9_PEDIDO,;
										SC9->C9_ITEM,;
										SC9->C9_SEQUEN,;
										SC9->C9_QTDLIB,;
										ROUND(nPrcVen,2),;
										SC9->C9_PRODUTO,;
										.f.,;
										SC9->(RecNo()),;
										SC5->(RecNo()),;
										SC6->(RecNo()),;
										SE4->(RecNo()),;
										SB1->(RecNo()),;
										SB2->(RecNo()),;
										SF4->(RecNo())})											
				
						SC6->(DBSKIP())

						IF _cPedido <> SC6->C6_NUM
							MaLiberOk({ _cPedido },.T.)	
							
						ENDIF												
					
					ENDDO  
					
					
					//�����������������������������������������������Ŀ
					//� Verifica se a Serie da Nota existe no sistema �
					//�������������������������������������������������
					DBSELECTAREA("SX5")
					SX5->(DBSETORDER(1))
					IF SX5->(DBSEEK(XFILIAL("SX5")+"01"+cSerie))
	
					    
						cNumNFAnt	:= SX5->X5_DESCRI
					
						     
						dBaseAnt	:= dDataBase
		
						                  
						BEGIN TRANSACTION
		
						dDataBase	:= Z10->Z10_DTNFE				       
						
						                     
						
						//��������������������������������������������������������������������Ŀ
						//� Altera numero da nota do SX5 para geracao da NF com numero correto �
						//����������������������������������������������������������������������
						RecLock("SX5",.F.)
							SX5->X5_DESCRI	:= Z10->Z10_NUMNFE
							SX5->X5_DESCSPA	:= Z10->Z10_NUMNFE
							SX5->X5_DESCENG	:= Z10->Z10_NUMNFE     
	     				SX5->(MSUNLOCK())
	     				
						//������������������Ŀ
						//� Gera Nota Fiscal �
						//��������������������
						cNota := MaPvlNfs(aPvlNfs,cSerie, .F.    , .F.    , .F.     , .T.    , .F.    , 0      , 0          , .F.  ) 
						//cNota := MaPvlNfs(aPvlNfs,cSerie,lMostraCtb,lAglutCtb,lCtbOnLine,lCtbCusto,lReajusta,nCalAcrs,nArredPrcLis,lAtuSA7,lECF)				
						  
						dDataBase	:= dBaseAnt
						
						RecLock("SX5",.F.)
							SX5->X5_DESCRI	:= cNumNFAnt
							SX5->X5_DESCSPA	:= cNumNFAnt
							SX5->X5_DESCENG	:= cNumNFAnt
	     				SX5->(MSUNLOCK())      
	     					     				
						Z10->(DBSEEK(XFILIAL("Z10")+SC5->C5_XCHVNFE+"S"))
						
						
	     				IF cNota == Z10->Z10_NUMNFE 		     				
		     					
							//������������������������������������������������������������Ŀ
							//� Grava informacoes adicionais para compatibilidade com SPEDs�
							//��������������������������������������������������������������
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
		     					     
								//����������������������Ŀ
								//� Altera Status do XML �
								//������������������������
		     					DBSELECTAREA("Z10") 
								RECLOCK("Z10",.F.)
									Z10->Z10_STATUS	:= "5"		
								MSUNLOCK()
								 
							ELSE
		        				aRet[2]		:= "Nota fiscal de Sa�da n�o foi gerada. [NOTA + SERIE]"+Z10->Z10_NUMNFE+" "+Z10->Z10_SERIE
								DisarmTransaction()	  									
								   
	     					ENDIF
	        		
	     				ELSE    
	     				
     						//������������������������������������������������������������������������Ŀ
							//� Caso a nota fiscal nao seja gerada com o mesmo nuero, realiza Rollback �
							//��������������������������������������������������������������������������
	     					DisarmTransaction()
	     				ENDIF					
		
						
						END TRANSACTION  
						
						
						//| Retorno
						IF !EMPTY(cNota)
							aRet[1]	:= .T.
							aRet[2] := cNota
						ENDIF
											
					ELSE
						aRet[2]		:= "Serie da Nota n�o cadastrada. [SERIE] "+cSerie
					ENDIF

				ENDIF
			ELSE
				aRet[2]		:= "A Nota Fiscal j� emitida anteriormente. [NOTA + SERIE]"+Z10->Z10_NUMNFE+" "+Z10->Z10_SERIE
			ENDIF
		ELSE
			aRet[2]		:= "Arquivo XML da DANFE nao encontrada. [C5_XCHVNFE] "+SC5->C5_XCHVNFE		
		ENDIF   		
	ELSE
		aRet[2]		:= "Pedido n�o encontrado. "+cNumPedido
	ENDIF
ELSE
	aRet[2]	:= "Este pedido nao foi gerado atraves de importacao de XML"
ENDIF

Return(aRet)

/*  

//cNota := MaPvlNfs(aPvlNfs,cSerie,lMostraCtb,lAglutCtb,lCtbOnLine,lCtbCusto,lReajusta,nCalAcrs,nArredPrcLis,lAtuSA7,lECF)												
�������������������������������������������������������������������������Ĵ��
���Descri��o �Inclusao de Nota fiscal de Saida atraves do PV liberado     ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Parametros�ExpA1: Array com os itens a serem gerados                   ���
���          �ExpC2: Serie da Nota Fiscal                                 ���
���          �ExpC3: Numero da Nota Fiscal                                ���
���          �ExpL4: Lancamento 610                                       ���
���          �ExpL5: Lancamento 620                                       ���
���          �ExpN6: Controle de contabilizacao                           ���
���          �ExpN7: Handle do arquivo de contabilizacao                  ���
���          �ExpL8: Reajuste de preco na nota fiscal                     ���
���          �ExpN9: Tipo de Acrescimo Financeiro                         ���
���          �ExpNA: Tipo de Arredondamento                               ���
���          �ExpLB: Atualiza Amarracao Cliente x Produto                 ���
���          �ExplC: Cupom Fiscal                                         ���
���          �ExpCD: Numero do Embarque de Exportacao                     ���
���          �ExpBE: Code block para complemento de atualizacao dos titu- ���
���          �       los financeiros.                                     ���
�������������������������������������������������������������������������Ĵ��
*/




/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � fRetPV   �Autor  �Augusto Ribeiro     � Data � 09/05/2012  ���
�������������������������������������������������������������������������͹��
���Desc.     � Busca numero do PV pela chave da danfe                     ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �      	                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
Static Function fRetPV(cChvNfe)
Local cRet		:= ""
Local cQuery	 := ""

cQuery	:= " SELECT C5_NUM "
cQuery	+= " FROM "+RetSqlName("SC5")
cQuery	+= " WHERE C5_FILIAL = '"+XFILIAL("SC5")+"' "
cQuery	+= " AND C5_XCHVNFE = '"+cChvNfe+"' "
cQuery	+= " AND D_E_L_E_T_ <> '*' "

If Select("QRYNUMPV") > 0
	QRYNUMPV->(DbCloseArea())
EndIf                   
                                        
cQuery:=ChangeQuery(cQuery)

MSGRUN("Aguarde....","SQL" ,		{|| dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQuery),'QRYNUMPV') } )

//TcQuery cQuery New Alias "NUMPV"

IF QRYNUMPV->(!EOF())
	cRet	:= QRYNUMPV->C5_NUM
ENDIF

QRYNUMPV->(DbCloseArea())

Return(cRet)

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Funcao    �CountItens  �Autor  �Thiago Nascimento  � Data � 28/01/2014 ���
�������������������������������������������������������������������������͹��
���Desc.     �Retorna total de registros nos itens para PROCREGUA         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
Static Function CountItens( _cFilial, _cDoc, _cSerie , _cFornec, _cLoja )

Local cQuery := ""
 
cQuery := "SELECT COUNT(*) AS TOTAL FROM " + RetSqlName("SD1")  + " WHERE D1_FILIAL = '" + _cFilial + "' "
cQuery += " AND D1_DOC = '"+ _cDoc +"' "
cQuery += " AND D1_SERIE = '"+ _cSerie +"' "
cQuery += " AND D1_FORNECE = '"+ _cFornec +"' "
cQuery += " AND D1_LOJA = '"+ _cLoja +"' "
cQuery += " AND D_E_L_E_T_ = '' "

IF Select("SD1TOT") > 0
	SD1TOT->(DBCLOSEAREA())
ENDIF

dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQuery),'SD1TOT')

DbSelectArea("SD1TOT")

Return(SD1TOT->TOTAL)  