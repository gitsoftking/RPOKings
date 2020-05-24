#INCLUDE "TBICONN.CH"
#INCLUDE "TOTVS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "apwebsrv.ch"

/***********************************************************************************************/

/* -------------------------------------------------------------

Fonte WSSE011.PRW 
Autor Felipe Azevedo dos Reis
Data 06/04/2020
Integração de Pré-Nota com o SE Suite

**********************   LINKS DE INTEGRAÇÃO   ********************** 

https://gdc-teste.softexpert.com/se/ws/wf_ws.php?wsdl   => Base Teste SE Suite
https://gdc.softexpert.com/se/ws/wf_ws.php?wsdl         => Base Producao SE Suite


**********************   MAPA DO PROGRAMA   ********************** 

WSSE011 - Programa principal que filtra os registros que estão pendentes para integração com o SE Suite
    INCNFE - Função que cria a instância no SE Suite
        FINCITENS - Função que inclui os itens da nota do XML (Compila)
        FINCVENCTO - Função que inclui os vencimentos da nota do XML (Compila)
        FEXCCAB - Não haja algum erro, essa função exclui o registro no SE Suite
    ALTNFE - Função que atualiza o status do registro da nota do XML (Compila) 
        FALTPED - Inclui os pedidos vinculados a nota ou pré-nota
            FCLRGRID - Apaga os dados da grid para inserir os dados novamente atualizados
        FCHVXML - Inclui os XMLs das notas fiscais de origem quando for devolução
            FCLRGRID - Apaga os dados da grid para inserir os dados novamente atualizados
        FEXCCAB - Não haja algum erro, essa função exclui o registro no SE Suite

u_zWLZ3IncLOG - Função externa para Inclusão do Log de Integração
u_zWLZ4UpdLOG - Função externa para Atualiza os dados do Log de Integração

------------------------------------------------------------- */
User Function JOBSE011()

Prepare Environment Empresa "03" Filial "05"

U_WSSE011()

Reset Environment

Return Nil

/***********************************************************************************************/

User Function WSSE011()

Local c_TipoAmb	:= ""
Local c_IDLock  := ""

Private c_Qry   := ""
Private c_Url   := ""
Private c_Login := ""
Private c_Pass  := ""
Private c_EOL   := Chr(13) + Chr(10)
Private o_Wsdl 

c_Login := AllTrim(GetMV("MV_XUSRSE"))
c_Pass  := AllTrim(GetMV("MV_XPSWSE"))

c_IDLock  := GetMV("MV_XWSSE11")

//Inclusao de SC no SE Suite
If LockByName(c_IDLock,.F.,.F.)

	//Verifica o tipo de ambiente
	c_TipoAmb := Upper(AllTrim(GetSrvProfString("TipoAmbienteGDC", "TESTE")))
	If c_TipoAmb == "PRODUCAO"
	    c_Url := "https://gdc.softexpert.com/se/ws/wf_ws.php?wsdl"
	Else
	    c_Url := "https://gdc-teste.softexpert.com/se/ws/wf_ws.php?wsdl"
	EndIf
	 	
    //SOLICITACAO PEDENTE DE APROVACAO
    c_Qry := "SELECT CASE WHEN Z10_IDSE = '' THEN 'Aguardando Pré Nota' " + c_EOL
    c_Qry += "            WHEN Z10_IDSE <> '' AND Z10_STATUS = '1' AND Z10_DTSE = '19000101' THEN 'Aguardando Pré Nota'" + c_EOL
    c_Qry += "            WHEN Z10_IDSE <> '' AND Z10_STATUS = '1' THEN 'Ocorrência'" + c_EOL
    c_Qry += "            WHEN Z10_IDSE <> '' AND Z10_STATUS = '2' THEN 'Pré-NF Gerada'" + c_EOL
    c_Qry += "            WHEN Z10_IDSE <> '' AND Z10_STATUS = '5' THEN 'Classificado' END AS STATUSNF" + c_EOL
    c_Qry += ", * " + c_EOL
    c_Qry += "FROM Z10030 Z10 (NOLOCK)" + c_EOL 
    c_Qry += "WHERE (Z10_DTSE = '' OR Z10_DTSE = '19000101') " + c_EOL
    c_Qry += "AND Z10_VALIDA = '2' " + c_EOL
    c_Qry += "AND Z10_DTIMP >= (GETDATE() - 90)" + c_EOL
    c_Qry += "AND Z10.D_E_L_E_T_ = ''" + c_EOL

    If Select("QRYWSSE") > 0
        QRYWSSE->(DbCloseArea())
    EndIf

    TcQuery c_Qry New Alias "QRYWSSE" 

    While QRYWSSE->(!Eof())

        //Efetua integracoes
        If AllTrim(QRYWSSE->STATUSNF) == "Aguardando Pré Nota" //Criacao da instancia no SE Suite            
            If Empty(QRYWSSE->Z10_DTSE)
                //Cria uma nova instancia (criacao de registro no Compila ou Exclusão/Estorno de Nota fiscal) 
                fIncNFE()
            Else
                //Altera status de instancia (Exclusão de Pré-Nota, Z10_DTSE = 19000101)
                fAltNFE(AllTrim(QRYWSSE->STATUSNF))
            EndIf 
        ElseIf AllTrim(QRYWSSE->STATUSNF) == "Ocorrência"
            //Erro ao gerar pre-nota
            fAltNFE(AllTrim(QRYWSSE->STATUSNF))
        ElseIf AllTrim(QRYWSSE->STATUSNF) == "Pré-NF Gerada"
            //Pre-Nota gerada com sucesso
            fAltNFE(AllTrim(QRYWSSE->STATUSNF))
        ElseIf AllTrim(QRYWSSE->STATUSNF) == "Classificado"
            //Classificação realizada com sucesso
            fAltNFE(AllTrim(QRYWSSE->STATUSNF))
        EndIf

        QRYWSSE->(DbSkip())

    EndDo

    //Fecha arquivo temporario
    If Select("QRYWSSE") > 0
        QRYWSSE->(DbCloseArea())
    EndIf

    UnLockByName(c_IDLock,.F.,.F.)
    
EndIf
 
Return Nil
 
/***********************************************************************************************/

/* -------------------------------------------------------------
Funcao fIncNFE
Autor Felipe Azevedo dos Reis
Data 13/12/2018
Criacao da Instancia no SE
------------------------------------------------------------- */

Static Function fIncNFE()
 
Local o_Xml
Local l_Ret     := .T.
Local l_CabInt  := .F. //Cabecalho foi integrado 
Local c_XML     := ""
Local c_WSRet   := ""
Local c_Emiss   := ""

Local n_RecLog  := 0
Local n_SeqIni  := Seconds()
Local n_SeqFim  := 0

Private c_Error	:= ""
Private c_Warning := ""
Private c_ChvNFE := QRYWSSE->Z10_CHVNFE
Private c_IDSE   := ""

// Cria o objeto da classe TWsdlManager
o_Wsdl := TWsdlManager():New()

// Desativa a validacao de certificado digital
o_Wsdl:bNoCheckPeerCert := .T.

// Faz o parse da URL
If o_Wsdl:ParseURL( c_Url )

    // Grava arquivos de log no Appserver
    o_Wsdl:lVerbose := .T.
    
    // Define se sempre enviara SOAPAction
    o_Wsdl:lAlwaysSendSA := .T.
    
    // Define a operacao do WS
    If o_Wsdl:SetOperation( "newWorkflowEditData" )
    
        // Preenche o header
        o_Wsdl:AddHttpHeader( "Authorization", "Basic " + Encode64(c_Login + ":" + c_Pass ))

        //Trata campo de data de emissao para formato do SOAP
        c_Emiss := Left(QRYWSSE->Z10_DTNFE,4) + '-' + SubStr(QRYWSSE->Z10_DTNFE,5,2) + '-' + SubStr(QRYWSSE->Z10_DTNFE,7,2)

        //Monta XML do cabecalho da SC
        c_XML := '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:urn="urn:workflow">' + c_EOL
        c_XML += '<soapenv:Header/>' + c_EOL
        c_XML += '<soapenv:Body>' + c_EOL
        c_XML += '   <urn:newWorkflowEditData>' + c_EOL
        c_XML += '      <!--You may enter the following 6 items in any order-->' + c_EOL
        c_XML += '      <urn:ProcessID>CSC-20-002</urn:ProcessID>' + c_EOL
        c_XML += '      <urn:WorkflowTitle>Fornecedor: ' + Left(AllTrim(QRYWSSE->Z10_RAZAO),30) + ' |  Nota: ' + AllTrim(QRYWSSE->Z10_NUMNFE) + '/' + AllTrim(QRYWSSE->Z10_SERIE) + '</urn:WorkflowTitle>' + c_EOL
        c_XML += '      <urn:UserID>sesuite</urn:UserID>' + c_EOL

        c_XML += '      <urn:EntityList>' + c_EOL
        c_XML += '         <urn:Entity>' + c_EOL
        c_XML += '            <urn:EntityID>recebimentonfe</urn:EntityID>' + c_EOL
        c_XML += '            <urn:EntityAttributeList>' + c_EOL

        c_XML += '               <urn:EntityAttribute>' + c_EOL    
        c_XML += '                  <urn:EntityAttributeID>situacaonfe</urn:EntityAttributeID>' + c_EOL
        c_XML += '                  <urn:EntityAttributeValue>Aguardando Pré-Nota</urn:EntityAttributeValue>' + c_EOL
        c_XML += '               </urn:EntityAttribute>' + c_EOL

        c_XML += '               <urn:EntityAttribute>' + c_EOL                     
        c_XML += '                  <urn:EntityAttributeID>filialgdc</urn:EntityAttributeID>' + c_EOL
        c_XML += '                  <urn:EntityAttributeValue>' + AllTrim(QRYWSSE->Z10_CODFIL) + '</urn:EntityAttributeValue>' + c_EOL
        c_XML += '               </urn:EntityAttribute>' + c_EOL

        c_XML += '               <urn:EntityAttribute>' + c_EOL                     
        c_XML += '                  <urn:EntityAttributeID>tiponfe</urn:EntityAttributeID>' + c_EOL
        c_XML += '                  <urn:EntityAttributeValue>' + AllTrim(QRYWSSE->Z10_TIPNFE) + '</urn:EntityAttributeValue>' + c_EOL
        c_XML += '               </urn:EntityAttribute>' + c_EOL

        c_XML += '               <urn:EntityAttribute>' + c_EOL                     
        c_XML += '                  <urn:EntityAttributeID>dtemissao</urn:EntityAttributeID>' + c_EOL
        c_XML += '                  <urn:EntityAttributeValue>' + c_Emiss + '</urn:EntityAttributeValue>' + c_EOL
        c_XML += '               </urn:EntityAttribute>' + c_EOL

        c_XML += '               <urn:EntityAttribute>' + c_EOL                     
        c_XML += '                  <urn:EntityAttributeID>numeronfe</urn:EntityAttributeID>' + c_EOL
        c_XML += '                  <urn:EntityAttributeValue>' + AllTrim(QRYWSSE->Z10_NUMNFE) + '</urn:EntityAttributeValue>' + c_EOL
        c_XML += '               </urn:EntityAttribute>' + c_EOL

        c_XML += '               <urn:EntityAttribute>' + c_EOL                     
        c_XML += '                  <urn:EntityAttributeID>serienfe</urn:EntityAttributeID>' + c_EOL
        c_XML += '                  <urn:EntityAttributeValue>' + AllTrim(QRYWSSE->Z10_SERIE) + '</urn:EntityAttributeValue>' + c_EOL
        c_XML += '               </urn:EntityAttribute>' + c_EOL

        c_XML += '               <urn:EntityAttribute>' + c_EOL                     
        c_XML += '                  <urn:EntityAttributeID>chaveacessonfe</urn:EntityAttributeID>' + c_EOL
        c_XML += '                  <urn:EntityAttributeValue>' + AllTrim(QRYWSSE->Z10_CHVNFE) + '</urn:EntityAttributeValue>' + c_EOL
        c_XML += '               </urn:EntityAttribute>' + c_EOL

        c_XML += '               <urn:EntityAttribute>' + c_EOL                     
        c_XML += '                  <urn:EntityAttributeID>cnpj</urn:EntityAttributeID>' + c_EOL
        c_XML += '                  <urn:EntityAttributeValue>' + AllTrim(QRYWSSE->Z10_CNPJ) + '</urn:EntityAttributeValue>' + c_EOL
        c_XML += '               </urn:EntityAttribute>' + c_EOL

        c_XML += '               <urn:EntityAttribute>' + c_EOL                     
        c_XML += '                  <urn:EntityAttributeID>nome</urn:EntityAttributeID>' + c_EOL
        c_XML += '                  <urn:EntityAttributeValue>' + AllTrim(QRYWSSE->Z10_RAZAO) + '</urn:EntityAttributeValue>' + c_EOL
        c_XML += '               </urn:EntityAttribute>' + c_EOL

        c_XML += '               <urn:EntityAttribute>' + c_EOL                     
        c_XML += '                  <urn:EntityAttributeID>valormercad</urn:EntityAttributeID>' + c_EOL
        c_XML += '                  <urn:EntityAttributeValue>' + AllTrim(Transform(QRYWSSE->Z10_FTVLIQ,"@E 999,999,999.99")) + '</urn:EntityAttributeValue>' + c_EOL
        c_XML += '               </urn:EntityAttribute>' + c_EOL

        c_XML += '               <urn:EntityAttribute>' + c_EOL                     
        c_XML += '                  <urn:EntityAttributeID>valorfrete</urn:EntityAttributeID>' + c_EOL
        c_XML += '                  <urn:EntityAttributeValue>' + AllTrim(Transform(QRYWSSE->Z10_VFRETE,"@E 999,999,999.99")) + '</urn:EntityAttributeValue>' + c_EOL
        c_XML += '               </urn:EntityAttribute>' + c_EOL     

        c_XML += '               <urn:EntityAttribute>' + c_EOL                     
        c_XML += '                  <urn:EntityAttributeID>valordesconto</urn:EntityAttributeID>' + c_EOL
        c_XML += '                  <urn:EntityAttributeValue>' + AllTrim(Transform(QRYWSSE->Z10_FTVDES,"@E 999,999,999.99")) + '</urn:EntityAttributeValue>' + c_EOL
        c_XML += '               </urn:EntityAttribute>' + c_EOL                      

        c_XML += '               <urn:EntityAttribute>' + c_EOL
        c_XML += '                  <urn:EntityAttributeID>valortotalnfe</urn:EntityAttributeID>' + c_EOL
        c_XML += '                  <urn:EntityAttributeValue>' + AllTrim(Transform(QRYWSSE->Z10_VLRTOT,"@E 999,999,999.99")) + '</urn:EntityAttributeValue>' + c_EOL
        c_XML += '               </urn:EntityAttribute>' + c_EOL   

        c_XML += '            </urn:EntityAttributeList>' + c_EOL

        c_XML += '         </urn:Entity>' + c_EOL
        c_XML += '      </urn:EntityList>' + c_EOL

        c_XML += '   </urn:newWorkflowEditData>' + c_EOL
        c_XML += '</soapenv:Body>' + c_EOL
        c_XML += '</soapenv:Envelope>' + c_EOL

        n_RecLog := u_zWLZ3IncLOG("P", "newWorkflowEditData", c_Url, "", c_XML, "Z10", c_ChvNFE, "WSSE011")

        //Executa WS cabecalho
        If o_Wsdl:SendSoapMsg(EncodeUTF8(c_XML))

            c_WSRet := o_Wsdl:GetSoapResponse()

            //Valida execucao
            If !Empty(c_WSRet) .And. ( !("FAULT" $ Upper(c_WSRet) .Or. "FAILURE" $ Upper(c_WSRet)) )

                o_Xml := XmlParser( c_WSRet, "_", @c_Error, @c_Warning )

                If o_Xml <> NIL 

                    //Atualiza o status para saber que o cabecalho foi integrado
                    l_CabInt := .T.

                    // Busca o ID do cabecalho gerado no SE Suite
                    c_IDSE := o_Xml:_SOAP_ENV_ENVELOPE:_SOAP_ENV_BODY:_NEWWORKFLOWEDITDATARESPONSE:_RECORDID:TEXT
                    
                    If fIncItens()//Altera a instancia e acrescenta os itens da nota
                        If !fIncVencto()//Altera a instancia e acrescenta os vencimentos da nota
                            l_Ret := .F.
                        EndIf
                    Else
                        l_Ret := .F.
                    EndIf

                Else
                    l_Ret := .F.
                EndIf
            
            Else
                l_Ret := .F.
            EndIf
        
        Else

            //Não conseguiu retorno do XML
            c_WSRet := "Erro no retorno do XML, erro: " + o_Wsdl:cError
            l_Ret := .F.

        EndIf

    Else

        //Não encontrou o método para criar a instancia
        c_WSRet := "Não foi encontrado o metodo, erro: " + o_Wsdl:cError 
        l_Ret := .F.

    EndIf

EndIf

n_SeqFim  := Seconds()

//Grava Log do cabeçalho
u_zWLZ4UpdLOG(n_RecLog, IIF(l_Ret,"1","2"), (n_SeqFim - n_SeqIni), c_WSRet, "", "Z10", c_ChvNFE, c_IDSE)

// Caso ocorra algum erro na execucao dos itens, sera apagada a instancia
If l_CabInt .And. !l_Ret
    fExcCab()
EndIf

//Atualiza o flag de integracao
If l_CabInt .And. l_Ret
    DbSelectArea("Z10")
    Z10->(DbSetOrder(1))//Z10_FILIAL, Z10_CHVNFE, Z10_TIPARQ, R_E_C_N_O_, D_E_L_E_T_
    IF Z10->(DbSeek(xFilial("Z10")+c_ChvNFE))
        RecLock("Z10",.F.)
        Z10->Z10_IDSE   := c_IDSE
        If QRYWSSE->Z10_STATUS == "1"//Só atualiza o status se estiver aguardando pré-nota, caso contrario deixa integrar a pré-nota ou a classificação            
            Z10->Z10_DTSE   := MsDate()
        EndIf
        Z10->(MsUnlock())
    EndIf
EndIf

Return Nil

/***********************************************************************************************/
 
/* -------------------------------------------------------------
Funcao fIncItens
Autor Felipe Azevedo dos Reis
Data 13/12/2018
Inclusão dos itens após a criação da instância no SE
------------------------------------------------------------- */

Static Function fIncItens()

Local o_Xml
Local l_Ret     := .T.
Local c_XML     := ""
Local c_WSRet   := ""

Local n_RecLog  := 0
Local n_SeqIni  := Seconds()
Local n_SeqFim  := 0

//Posiciono no primeiro registro dos itens do XML da compila
DbSelectArea("Z11")
Z11->(DbSetOrder(1))//Z11_FILIAL, Z11_CHVNFE, Z11_TIPARQ, Z11_ITEM, R_E_C_N_O_, D_E_L_E_T_
Z11->(DbGoTop())
If Z11->(DBSeek(xFilial("Z11")+c_ChvNFE))

    //Monta XML dos itens
    c_XML := '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:urn="urn:workflow">' + c_EOL
    c_XML += '<soapenv:Header/>' + c_EOL
    c_XML += '<soapenv:Body>' + c_EOL
    c_XML += '    <urn:newChildEntityRecordList>' + c_EOL
    c_XML += '        <!--You may enter the following 4 items in any order-->' + c_EOL
    c_XML += '        <urn:WorkflowID>' + c_IDSE + '</urn:WorkflowID>' + c_EOL
    c_XML += '        <urn:MainEntityID>recebimentonfe</urn:MainEntityID>' + c_EOL
    c_XML += '        <urn:ChildRelationshipID>prodnfexrecebim</urn:ChildRelationshipID>' + c_EOL
    c_XML += '        <urn:EntityRecordList>' + c_EOL

    While Z11->(!Eof()) .And. Z11->Z11_CHVNFE == c_ChvNFE

        c_XML += '            <!--Zero or more repetitions:-->' + c_EOL
        c_XML += '            <urn:EntityRecord>' + c_EOL
        c_XML += '            <!--Optional:-->' + c_EOL
        c_XML += '            <urn:EntityAttributeList>' + c_EOL
        c_XML += '                <!--Zero or more repetitions:-->' + c_EOL

        c_XML += '                <urn:EntityAttribute>' + c_EOL
        c_XML += '                  <urn:EntityAttributeID>codprodclifor</urn:EntityAttributeID>' + c_EOL
        c_XML += '                  <urn:EntityAttributeValue>' + AllTrim(Z11->Z11_CODPRO) + '</urn:EntityAttributeValue>' + c_EOL
        c_XML += '                </urn:EntityAttribute>' + c_EOL

        c_XML += '                <urn:EntityAttribute>' + c_EOL
        c_XML += '                  <urn:EntityAttributeID>descprodclifor</urn:EntityAttributeID>' + c_EOL
        c_XML += '                  <urn:EntityAttributeValue>' + AllTrim(Z11->Z11_DESPRO) + '</urn:EntityAttributeValue>' + c_EOL
        c_XML += '                </urn:EntityAttribute>' + c_EOL

        c_XML += '                <urn:EntityAttribute>' + c_EOL
        c_XML += '                  <urn:EntityAttributeID>npcnfe</urn:EntityAttributeID>' + c_EOL
        c_XML += '                  <urn:EntityAttributeValue>' + AllTrim(Z11->Z11_NUMPC) + '</urn:EntityAttributeValue>' + c_EOL
        c_XML += '                </urn:EntityAttribute>' + c_EOL

        c_XML += '                <urn:EntityAttribute>' + c_EOL
        c_XML += '                  <urn:EntityAttributeID>unnfe</urn:EntityAttributeID>' + c_EOL
        c_XML += '                  <urn:EntityAttributeValue>' + AllTrim(Z11->Z11_UM) + '</urn:EntityAttributeValue>' + c_EOL
        c_XML += '                </urn:EntityAttribute>' + c_EOL

        c_XML += '                <urn:EntityAttribute>' + c_EOL
        c_XML += '                  <urn:EntityAttributeID>quantidadenfe2</urn:EntityAttributeID>' + c_EOL
        c_XML += '                  <urn:EntityAttributeValue>' + AllTrim(Str(Z11->Z11_QUANT)) + '</urn:EntityAttributeValue>' + c_EOL
        c_XML += '                </urn:EntityAttribute>' + c_EOL

        c_XML += '                <urn:EntityAttribute>' + c_EOL
        c_XML += '                  <urn:EntityAttributeID>vlruninfe</urn:EntityAttributeID>' + c_EOL
        c_XML += '                  <urn:EntityAttributeValue>' + AllTrim(Str(Z11->Z11_VLRUNI)) + '</urn:EntityAttributeValue>' + c_EOL
        c_XML += '                </urn:EntityAttribute>' + c_EOL

        c_XML += '                <urn:EntityAttribute>' + c_EOL
        c_XML += '                  <urn:EntityAttributeID>vlrtotalnfe</urn:EntityAttributeID>' + c_EOL
        c_XML += '                  <urn:EntityAttributeValue>' + AllTrim(Str(Z11->Z11_VLRTOT)) + '</urn:EntityAttributeValue>' + c_EOL
        c_XML += '                </urn:EntityAttribute>' + c_EOL

        c_XML += '                <urn:EntityAttribute>' + c_EOL
        c_XML += '                  <urn:EntityAttributeID>itempcnfe</urn:EntityAttributeID>' + c_EOL
        c_XML += '                  <urn:EntityAttributeValue>' + AllTrim(Z11->Z11_ITEMPC) + '</urn:EntityAttributeValue>' + c_EOL
        c_XML += '                </urn:EntityAttribute>' + c_EOL

        c_XML += '                <urn:EntityAttribute>' + c_EOL
        c_XML += '                  <urn:EntityAttributeID>cfopnfe</urn:EntityAttributeID>' + c_EOL
        c_XML += '                  <urn:EntityAttributeValue>' + AllTrim(Z11->Z11_CFOP) + '</urn:EntityAttributeValue>' + c_EOL
        c_XML += '                </urn:EntityAttribute>' + c_EOL

        c_XML += '            </urn:EntityAttributeList>' + c_EOL
        c_XML += '            </urn:EntityRecord>' + c_EOL

        Z11->(DbSkip())

    EndDo

    c_XML += '        </urn:EntityRecordList>' + c_EOL
    c_XML += '    </urn:newChildEntityRecordList>' + c_EOL
    c_XML += '</soapenv:Body>' + c_EOL
    c_XML += '</soapenv:Envelope>' + c_EOL

    //Grava Log do inicio
    n_RecLog := u_zWLZ3IncLOG("P", "newChildEntityRecordList", c_Url, "", c_XML, "Z11", c_ChvNFE, "WSSE011")

    //Executa WS dos Itens
    If o_Wsdl:SendSoapMsg(EncodeUTF8(c_XML))

        c_WSRet := o_Wsdl:GetSoapResponse()

        //Valida execucao
        If !Empty(c_WSRet) .And. ( !("FAULT" $ Upper(c_WSRet) .Or. "FAILURE" $ Upper(c_WSRet)) )

            o_Xml := XmlParser( c_WSRet, "_", @c_Error, @c_Warning )

            If o_Xml == NIL 

                l_Ret := .F.

            EndIf
        
        Else

        l_Ret := .F.

        EndIf
    
    Else

        //Não conseguiu retorno do XML
        c_WSRet := "Erro no retorno do XML, erro: " + o_Wsdl:cError
        l_Ret := .F.

    EndIf

    n_SeqFim  := Seconds()

    //Grava Log Final
    u_zWLZ4UpdLOG(n_RecLog, IIF(l_Ret,"1","2"), (n_SeqFim - n_SeqIni), c_WSRet, "", "Z11", c_ChvNFE, c_IDSE)

EndIf

Return l_Ret

/***********************************************************************************************/
 
/* -------------------------------------------------------------
Funcao fIncVencto
Autor Felipe Azevedo dos Reis
Data 13/12/2018
Inclusão dos vencimentos após a criação da instância no SE
------------------------------------------------------------- */

Static Function fIncVencto()

Local o_Xml
Local l_Ret     := .T.
Local c_XML     := ""
Local c_WSRet   := ""
Local c_Vencto  := ""

Local n_RecLog  := 0
Local n_SeqIni  := Seconds()
Local n_SeqFim  := 0

//Posiciono no primeiro registro dos vencimentos do XML da compila
DbSelectArea("Z13")
Z13->(DbSetOrder(1))//Z13_FILIAL, Z13_CHVNFE, Z13_TIPARQ, Z13_ITEM, R_E_C_N_O_, D_E_L_E_T_
Z13->(DbGoTop())
If Z13->(DBSeek(xFilial("Z13")+c_ChvNFE))

    //Monta XML dos itens
    c_XML := '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:urn="urn:workflow">' + c_EOL
    c_XML += '<soapenv:Header/>' + c_EOL
    c_XML += '<soapenv:Body>' + c_EOL
    c_XML += '    <urn:newChildEntityRecordList>' + c_EOL
    c_XML += '        <!--You may enter the following 4 items in any order-->' + c_EOL
    c_XML += '        <urn:WorkflowID>' + c_IDSE + '</urn:WorkflowID>' + c_EOL
    c_XML += '        <urn:MainEntityID>recebimentonfe</urn:MainEntityID>' + c_EOL
    c_XML += '        <urn:ChildRelationshipID>relduplicareceb</urn:ChildRelationshipID>' + c_EOL
    c_XML += '        <urn:EntityRecordList>' + c_EOL

    While Z13->(!Eof()) .And. Z13->Z13_CHVNFE == c_ChvNFE

        //Trata campo de data de vencimento para formato do SOAP
        c_Vencto := Left(DtoS(Z13->Z13_DTVENC),4) + '-' + SubStr(DtoS(Z13->Z13_DTVENC),5,2) + '-' + SubStr(DtoS(Z13->Z13_DTVENC),7,2)

        c_XML += '            <!--Zero or more repetitions:-->' + c_EOL
        c_XML += '            <urn:EntityRecord>' + c_EOL
        c_XML += '            <!--Optional:-->' + c_EOL
        c_XML += '            <urn:EntityAttributeList>' + c_EOL
        c_XML += '                <!--Zero or more repetitions:-->' + c_EOL

        c_XML += '                <urn:EntityAttribute>' + c_EOL
        c_XML += '                  <urn:EntityAttributeID>dtvctonfe1</urn:EntityAttributeID>' + c_EOL
        c_XML += '                  <urn:EntityAttributeValue>' + c_Vencto + '</urn:EntityAttributeValue>' + c_EOL
        c_XML += '                </urn:EntityAttribute>' + c_EOL

        c_XML += '                <urn:EntityAttribute>' + c_EOL
        c_XML += '                  <urn:EntityAttributeID>vlrparcela</urn:EntityAttributeID>' + c_EOL
        c_XML += '                  <urn:EntityAttributeValue>' + AllTrim(Str(Z13->Z13_VALOR)) + '</urn:EntityAttributeValue>' + c_EOL
        c_XML += '                </urn:EntityAttribute>' + c_EOL

        c_XML += '            </urn:EntityAttributeList>' + c_EOL
        c_XML += '            </urn:EntityRecord>' + c_EOL

        Z13->(DbSkip())

    EndDo

    c_XML += '        </urn:EntityRecordList>' + c_EOL
    c_XML += '    </urn:newChildEntityRecordList>' + c_EOL
    c_XML += '</soapenv:Body>' + c_EOL
    c_XML += '</soapenv:Envelope>' + c_EOL

    //Grava Log do inicio
    n_RecLog := u_zWLZ3IncLOG("P", "newChildEntityRecordList", c_Url, "", c_XML, "Z13", c_ChvNFE, "WSSE011")

    //Executa WS dos Itens
    If o_Wsdl:SendSoapMsg(EncodeUTF8(c_XML))

        c_WSRet := o_Wsdl:GetSoapResponse()

        //Valida execucao
        If !Empty(c_WSRet) .And. ( !("FAULT" $ Upper(c_WSRet) .Or. "FAILURE" $ Upper(c_WSRet)) )

            o_Xml := XmlParser( c_WSRet, "_", @c_Error, @c_Warning )

            If o_Xml == NIL 

                l_Ret := .F.

            EndIf
        
        Else

        l_Ret := .F.

        EndIf
    
    Else

        //Não conseguiu retorno do XML
        c_WSRet := "Erro no retorno do XML, erro: " + o_Wsdl:cError
        l_Ret := .F.

    EndIf

    n_SeqFim  := Seconds()

    //Grava Log Final
    u_zWLZ4UpdLOG(n_RecLog, IIF(l_Ret,"1","2"), (n_SeqFim - n_SeqIni), c_WSRet, "", "Z13", c_ChvNFE, c_IDSE)

EndIf

Return l_Ret

/***********************************************************************************************/

/* -------------------------------------------------------------
Funcao fExcCab
Autor Felipe Azevedo dos Reis
Data 09/04/2020
Executa a exclusao da Solicitacao para o SE Suite
------------------------------------------------------------- */

Static Function fExcCab()

Local o_Xml
Local l_Ret    := .T.
Local c_XML    := ""
Local c_WSRet  := ""

Local n_RecLog  := 0
Local n_SeqIni  := Seconds()
Local n_SeqFim  := 0

c_XML := '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:urn="urn:workflow">' + c_EOL
c_XML += '<soapenv:Header/>' + c_EOL
c_XML += '<soapenv:Body>' + c_EOL
c_XML += '    <urn:cancelWorkflow>' + c_EOL
c_XML += '        <!--You may enter the following 3 items in any order-->' + c_EOL
c_XML += '        <urn:WorkflowID>' + c_IDSE + '</urn:WorkflowID>' + c_EOL
c_XML += '        <urn:Explanation>Cancelado</urn:Explanation>' + c_EOL
c_XML += '        <urn:UserID>sesuite</urn:UserID>' + c_EOL
c_XML += '    </urn:cancelWorkflow>' + c_EOL
c_XML += '</soapenv:Body>' + c_EOL
c_XML += '</soapenv:Envelope>' + c_EOL

//Grava Log do inicio
n_RecLog := u_zWLZ3IncLOG("P", "cancelWorkflow", c_Url, "", c_XML, "Z10", c_ChvNFE, "WSSE011")

If o_Wsdl:SendSoapMsg(EncodeUTF8(c_XML))

    c_WSRet := o_Wsdl:GetSoapResponse()

    If !Empty(c_WSRet) .And. ( !("FAULT" $ Upper(c_WSRet) .Or. "FAILURE" $ Upper(c_WSRet)) )

        o_Xml := XmlParser( c_WSRet, "_", @c_Error, @c_Warning )

        If o_Xml == NIL 

            l_Ret := .F.

        EndIf

    Else
        
        l_Ret := .F.

    EndIf

Else
    
    c_WSRet := "Erro no retorno do XML, erro: " + o_Wsdl:cError
    l_Ret := .F.

EndIf

n_SeqFim  := Seconds()

//Grava Log Final
u_zWLZ4UpdLOG(n_RecLog, IIF(l_Ret,"1","2"), (n_SeqFim - n_SeqIni), c_WSRet, "", "Z10", c_ChvNFE, c_IDSE)

Return l_Ret

/***********************************************************************************************/

/***********************************************************************************************/

/* -------------------------------------------------------------
Funcao fAltNFE
Autor Felipe Azevedo dos Reis
Data 13/12/2018
Altera Status no SE
------------------------------------------------------------- */

Static Function fAltNFE(c_Status)
 
Local o_Xml
Local l_Ret     := .T.
Local l_CabInt  := .F. //Cabecalho foi integrado 
Local c_XML     := ""
Local c_WSRet   := ""

Local n_RecLog  := 0
Local n_SeqIni  := Seconds()
Local n_SeqFim  := 0

Private c_Error	:= ""
Private c_Warning := ""
Private c_IDSE   := QRYWSSE->Z10_IDSE
Private c_ChvNFE := QRYWSSE->Z10_CHVNFE

DbSelectArea("Z10")
Z10->(DbSetOrder(1))//Z10_FILIAL, Z10_CHVNFE, Z10_TIPARQ, R_E_C_N_O_, D_E_L_E_T_
Z10->(DbSeek(xFilial("Z10")+QRYWSSE->Z10_CHVNFE))

// Cria o objeto da classe TWsdlManager
o_Wsdl := TWsdlManager():New()

// Desativa a validacao de certificado digital
o_Wsdl:bNoCheckPeerCert := .T.

// Faz o parse da URL
If o_Wsdl:ParseURL( c_Url )

    // Grava arquivos de log no Appserver
    o_Wsdl:lVerbose := .T.
    
    // Define se sempre enviara SOAPAction
    o_Wsdl:lAlwaysSendSA := .T.
    
    // Define a operacao do WS
    If o_Wsdl:SetOperation( "editEntityRecord" )
    
        // Preenche o header
        o_Wsdl:AddHttpHeader( "Authorization", "Basic " + Encode64(c_Login + ":" + c_Pass ))

        //Monta XML do cabecalho da SC
        c_XML := '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:urn="urn:workflow">' + c_EOL
        c_XML += '   <soapenv:Header/>' + c_EOL
        c_XML += '   <soapenv:Body>' + c_EOL
        c_XML += '      <urn:editEntityRecord>' + c_EOL
        c_XML += '         <!--You may enter the following 5 items in any order-->' + c_EOL
        c_XML += '         <urn:WorkflowID>' + Z10->Z10_IDSE + '</urn:WorkflowID>' + c_EOL
        c_XML += '         <urn:EntityID>recebimentonfe</urn:EntityID>' + c_EOL
         
        c_XML += '         <urn:EntityAttributeList>' + c_EOL

        c_XML += '            <urn:EntityAttribute>' + c_EOL
        c_XML += '               <urn:EntityAttributeID>situacaonfe</urn:EntityAttributeID>' + c_EOL
        c_XML += '               <urn:EntityAttributeValue>' + c_Status + '</urn:EntityAttributeValue>' + c_EOL
        c_XML += '            </urn:EntityAttribute>' + c_EOL

        c_XML += '            <urn:EntityAttribute>' + c_EOL
        c_XML += '               <urn:EntityAttributeID>ocorrencianfe</urn:EntityAttributeID>' + c_EOL
        c_XML += '               <urn:EntityAttributeValue>' + Z10->Z10_LOGINT + '</urn:EntityAttributeValue>' + c_EOL
        c_XML += '            </urn:EntityAttribute>' + c_EOL

        c_XML += '         </urn:EntityAttributeList>' + c_EOL
         
        c_XML += '      </urn:editEntityRecord>' + c_EOL
        c_XML += '   </soapenv:Body>' + c_EOL
        c_XML += '</soapenv:Envelope>' + c_EOL

        n_RecLog := u_zWLZ3IncLOG("P", "editEntityRecord", c_Url, "", c_XML, "Z10", c_ChvNFE, "WSSE011")

        //Executa WS cabecalho
        If o_Wsdl:SendSoapMsg(EncodeUTF8(c_XML))

            c_WSRet := o_Wsdl:GetSoapResponse()

            //Valida execucao
            If !Empty(c_WSRet) .And. ( !("FAULT" $ Upper(c_WSRet) .Or. "FAILURE" $ Upper(c_WSRet)) )

                o_Xml := XmlParser( c_WSRet, "_", @c_Error, @c_Warning )

                If o_Xml <> NIL 

                    //Atualiza o status para saber que o cabecalho foi integrado
                    l_CabInt := .T.

                    If c_Status <> "Ocorrência" 

                        //Grava os dados do pedido
                        l_Ret := fAltPed()  

                        //Grava os dados da Chave da nota fiscal de origem
                        If l_Ret .And. Z10->Z10_TIPNFE == "D"
                            l_Ret := fChvXML()  
                        EndIf

                    EndIf

                Else
                    l_Ret := .F.
                EndIf
            
            Else
                l_Ret := .F.
            EndIf
        
        Else

            //Não conseguiu retorno do XML
            c_WSRet := "Erro no retorno do XML, erro: " + o_Wsdl:cError
            l_Ret := .F.

        EndIf

    Else

        //Não encontrou o método para criar a instancia
        c_WSRet := "Não foi encontrado o metodo, erro: " + o_Wsdl:cError 
        l_Ret := .F.

    EndIf

EndIf

n_SeqFim  := Seconds()

//Grava Log do cabeçalho
u_zWLZ4UpdLOG(n_RecLog, IIF(l_Ret,"1","2"), (n_SeqFim - n_SeqIni), c_WSRet, "", "Z10", c_ChvNFE, c_IDSE)

// Caso ocorra algum erro na execucao dos itens, sera apagada a instancia
If l_CabInt .And. !l_Ret
    fExcCab()
EndIf

//Atualiza o flag de integracao
If l_CabInt .And. l_Ret
    DbSelectArea("Z10")
    Z10->(DbSetOrder(1))//Z10_FILIAL, Z10_CHVNFE, Z10_TIPARQ, R_E_C_N_O_, D_E_L_E_T_
    IF Z10->(DbSeek(xFilial("Z10")+c_ChvNFE))
        RecLock("Z10",.F.)
        If c_Status == "Aguardando Pré Nota" .And. QRYWSSE->Z10_STATUS <> "1"
            Z10->Z10_DTSE   := CtoD("//")
        Else
            Z10->Z10_DTSE   := MsDate()
        EndIf
        Z10->(MsUnlock())
    EndIf
EndIf

Return Nil

/***********************************************************************************************/
 
/* -------------------------------------------------------------
Funcao fAltPed
Autor Felipe Azevedo dos Reis
Data 13/12/2018
Inclusão dos itens dos pedidos na nota
------------------------------------------------------------- */

Static Function fAltPed()

Local o_Xml
Local l_Ret     := .T.
Local c_XML     := ""
Local c_WSRet   := ""
Local l_TemItem := .F.

Local n_RecLog  := 0
Local n_SeqIni  := Seconds()
Local n_SeqFim  := 0

//Apaga os dados da Grid, para não duplicar
fClrGrid(c_IDSE, "recebimentonfe", "pcxrecebnfe")

//Posiciono no primeiro registro dos vencimentos do XML da compila
DbSelectArea("SF1")
SF1->(DbSetOrder(8))//F1_FILIAL, F1_CHVNFE, R_E_C_N_O_, D_E_L_E_T_

DbSelectArea("SD1")
SD1->(DbSetOrder(1))//D1_FILIAL, D1_DOC, D1_SERIE, D1_FORNECE, D1_LOJA, D1_COD, D1_ITEM, R_E_C_N_O_, D_E_L_E_T_
SD1->(DbGoTop())

DbSelectArea("SC7")
SC7->(DbSetOrder(4))//C7_FILIAL, C7_PRODUTO, C7_NUM, C7_ITEM, C7_SEQUEN, R_E_C_N_O_, D_E_L_E_T_

//Posiciona no cabecalho da nota
If SF1->(DBSeek(QRYWSSE->(Z10_CODFIL+Z10_CHVNFE)))

    //Monta XML dos itens
    c_XML := '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:urn="urn:workflow">' + c_EOL
    c_XML += '<soapenv:Header/>' + c_EOL
    c_XML += '<soapenv:Body>' + c_EOL
    c_XML += '    <urn:newChildEntityRecordList>' + c_EOL
    c_XML += '        <!--You may enter the following 4 items in any order-->' + c_EOL
    c_XML += '        <urn:WorkflowID>' + c_IDSE + '</urn:WorkflowID>' + c_EOL
    c_XML += '        <urn:MainEntityID>recebimentonfe</urn:MainEntityID>' + c_EOL
    c_XML += '        <urn:ChildRelationshipID>pcxrecebnfe</urn:ChildRelationshipID>' + c_EOL
    c_XML += '        <urn:EntityRecordList>' + c_EOL

    //Posiciona nos itens da nota
    SD1->(DBSeek(SF1->(F1_FILIAL + F1_DOC + F1_SERIE + F1_FORNECE + F1_LOJA)))

    While SD1->(!Eof()) .And.  SF1->(F1_FILIAL + F1_DOC + F1_SERIE + F1_FORNECE + F1_LOJA) == SD1->(D1_FILIAL + D1_DOC + D1_SERIE + D1_FORNECE + D1_LOJA)

        //Posiciona nos pedidos relacionados na nota
        If SC7->(DBSeek(SD1->(D1_FILIAL + D1_COD + D1_PEDIDO + D1_ITEMPC)))

            l_TemItem := .T.

            c_XML += '            <!--Zero or more repetitions:-->' + c_EOL
            c_XML += '            <urn:EntityRecord>' + c_EOL
            c_XML += '            <!--Optional:-->' + c_EOL
            c_XML += '            <urn:EntityAttributeList>' + c_EOL
            c_XML += '                <!--Zero or more repetitions:-->' + c_EOL

            c_XML += '                <urn:EntityAttribute>' + c_EOL
            c_XML += '                  <urn:EntityAttributeID>codprodpc</urn:EntityAttributeID>' + c_EOL
            c_XML += '                  <urn:EntityAttributeValue>' + SC7->C7_PRODUTO + '</urn:EntityAttributeValue>' + c_EOL
            c_XML += '                </urn:EntityAttribute>' + c_EOL

            c_XML += '                <urn:EntityAttribute>' + c_EOL
            c_XML += '                  <urn:EntityAttributeID>descprodpc</urn:EntityAttributeID>' + c_EOL
            c_XML += '                  <urn:EntityAttributeValue>' + SC7->C7_DESCRI + '</urn:EntityAttributeValue>' + c_EOL
            c_XML += '                </urn:EntityAttribute>' + c_EOL

            c_XML += '                <urn:EntityAttribute>' + c_EOL
            c_XML += '                  <urn:EntityAttributeID>unpc</urn:EntityAttributeID>' + c_EOL
            c_XML += '                  <urn:EntityAttributeValue>' + SC7->C7_UM + '</urn:EntityAttributeValue>' + c_EOL
            c_XML += '                </urn:EntityAttribute>' + c_EOL

            c_XML += '                <urn:EntityAttribute>' + c_EOL
            c_XML += '                  <urn:EntityAttributeID>quantidadepc</urn:EntityAttributeID>' + c_EOL
            c_XML += '                  <urn:EntityAttributeValue>' + AllTrim(Str(SC7->C7_QUANT)) + '</urn:EntityAttributeValue>' + c_EOL
            c_XML += '                </urn:EntityAttribute>' + c_EOL

            c_XML += '                <urn:EntityAttribute>' + c_EOL
            c_XML += '                  <urn:EntityAttributeID>vlrunitpc</urn:EntityAttributeID>' + c_EOL
            c_XML += '                  <urn:EntityAttributeValue>' + AllTrim(Str(SC7->C7_PRECO)) + '</urn:EntityAttributeValue>' + c_EOL
            c_XML += '                </urn:EntityAttribute>' + c_EOL

            c_XML += '                <urn:EntityAttribute>' + c_EOL
            c_XML += '                  <urn:EntityAttributeID>vlrtotalpc</urn:EntityAttributeID>' + c_EOL
            c_XML += '                  <urn:EntityAttributeValue>' + AllTrim(Str(SC7->C7_TOTAL)) + '</urn:EntityAttributeValue>' + c_EOL
            c_XML += '                </urn:EntityAttribute>' + c_EOL

            c_XML += '                <urn:EntityAttribute>' + c_EOL
            c_XML += '                  <urn:EntityAttributeID>npc</urn:EntityAttributeID>' + c_EOL
            c_XML += '                  <urn:EntityAttributeValue>' + SC7->C7_NUM + '</urn:EntityAttributeValue>' + c_EOL
            c_XML += '                </urn:EntityAttribute>' + c_EOL

            c_XML += '                <urn:EntityAttribute>' + c_EOL
            c_XML += '                  <urn:EntityAttributeID>itempc</urn:EntityAttributeID>' + c_EOL
            c_XML += '                  <urn:EntityAttributeValue>' + SC7->C7_ITEM + '</urn:EntityAttributeValue>' + c_EOL
            c_XML += '                </urn:EntityAttribute>' + c_EOL

            c_XML += '                <urn:EntityAttribute>' + c_EOL
            c_XML += '                  <urn:EntityAttributeID>segundaumpc</urn:EntityAttributeID>' + c_EOL
            c_XML += '                  <urn:EntityAttributeValue>' + SC7->C7_SEGUM + '</urn:EntityAttributeValue>' + c_EOL
            c_XML += '                </urn:EntityAttribute>' + c_EOL

            c_XML += '                <urn:EntityAttribute>' + c_EOL
            c_XML += '                  <urn:EntityAttributeID>segundaqtdpc</urn:EntityAttributeID>' + c_EOL
            c_XML += '                  <urn:EntityAttributeValue>' + AllTrim(Str(SC7->C7_QTSEGUM)) + '</urn:EntityAttributeValue>' + c_EOL
            c_XML += '                </urn:EntityAttribute>' + c_EOL

            c_XML += '                <urn:EntityAttribute>' + c_EOL
            c_XML += '                  <urn:EntityAttributeID>segundovlrunipc</urn:EntityAttributeID>' + c_EOL
            c_XML += '                  <urn:EntityAttributeValue>' + AllTrim(Str(SC7->C7_TOTAL/SC7->C7_QTSEGUM)) + '</urn:EntityAttributeValue>' + c_EOL
            c_XML += '                </urn:EntityAttribute>' + c_EOL

            c_XML += '            </urn:EntityAttributeList>' + c_EOL
            c_XML += '            </urn:EntityRecord>' + c_EOL
        
        EndIf

        SD1->(DbSkip())

    EndDo

    c_XML += '        </urn:EntityRecordList>' + c_EOL
    c_XML += '    </urn:newChildEntityRecordList>' + c_EOL
    c_XML += '</soapenv:Body>' + c_EOL
    c_XML += '</soapenv:Envelope>' + c_EOL

    If l_TemItem

        //Grava Log do inicio
        n_RecLog := u_zWLZ3IncLOG("P", "newChildEntityRecordList", c_Url, "", c_XML, "SC7", c_ChvNFE, "WSSE011")

        //Executa WS dos Itens
        If o_Wsdl:SendSoapMsg(EncodeUTF8(c_XML))

            c_WSRet := o_Wsdl:GetSoapResponse()

            //Valida execucao
            If !Empty(c_WSRet) .And. ( !("FAULT" $ Upper(c_WSRet) .Or. "FAILURE" $ Upper(c_WSRet)) )

                o_Xml := XmlParser( c_WSRet, "_", @c_Error, @c_Warning )

                If o_Xml == NIL 

                    l_Ret := .F.

                EndIf
            
            Else

            l_Ret := .F.

            EndIf
        
        Else

            //Não conseguiu retorno do XML
            c_WSRet := "Erro no retorno do XML, erro: " + o_Wsdl:cError
            l_Ret := .F.

        EndIf

        n_SeqFim  := Seconds()

        //Grava Log Final
        u_zWLZ4UpdLOG(n_RecLog, IIF(l_Ret,"1","2"), (n_SeqFim - n_SeqIni), c_WSRet, "", "SC7", c_ChvNFE, c_IDSE)

    EndIf

EndIf

Return l_Ret

/***********************************************************************************************/
 
/* -------------------------------------------------------------
Funcao fChvXML
Autor Felipe Azevedo dos Reis
Data 13/12/2018
Inclusão das chaves dos XMLs de origem
------------------------------------------------------------- */

Static Function fChvXML()

Local o_Xml
Local l_Ret     := .T.
Local c_XML     := ""
Local c_WSRet   := ""
Local l_TemItem := .F.

Local n_RecLog  := 0
Local n_SeqIni  := Seconds()
Local n_SeqFim  := 0

Local c_Qry := ""

//Apaga os dados da Grid, para não duplicar
fClrGrid(c_IDSE, "recebimentonfe", "reldocorigreceb")

c_Qry := "SELECT DISTINCT D1_NFORI + '/' + D1_SERIORI AS NOTA "
c_Qry += "		, F2_CHVNFE AS CHAVE "
c_Qry += "FROM Z10030 Z10 (NOLOCK) "

c_Qry += "	INNER JOIN SF1030 SF1 (NOLOCK) "
c_Qry += "	ON F1_FILIAL = Z10_CODFIL "
c_Qry += "	AND F1_CHVNFE = Z10_CHVNFE "
c_Qry += "	AND SF1.D_E_L_E_T_ = '' "

c_Qry += "	INNER JOIN SD1030 SD1 (NOLOCK) "
c_Qry += "	ON F1_FILIAL = D1_FILIAL "
c_Qry += "	AND F1_DOC = D1_DOC "
c_Qry += "	AND F1_SERIE = D1_SERIE "
c_Qry += "	AND F1_FORNECE = D1_FORNECE "
c_Qry += "	AND F1_LOJA = D1_LOJA "
c_Qry += "	AND SD1.D_E_L_E_T_ = '' "

c_Qry += "	INNER JOIN SF2030 SF2 (NOLOCK) "
c_Qry += "	ON F2_FILIAL = D1_FILIAL "
c_Qry += "	AND F2_DOC = D1_NFORI "
//TODO -- AND F2_SERIE = D1_SERIORI
c_Qry += "	AND F2_CLIENTE = D1_FORNECE "
c_Qry += "	AND F2_LOJA = D1_LOJA "
c_Qry += "	AND SF2.D_E_L_E_T_ = '' "

c_Qry += "WHERE Z10_CODFIL = '" + QRYWSSE->Z10_CODFIL + "' "
c_Qry += "AND Z10_CHVNFE = '" + QRYWSSE->Z10_CHVNFE + "' "
c_Qry += "AND Z10.D_E_L_E_T_ = '' "

If Select("QRYCHV") > 0
    QRYCHV->(DbCloseArea())
EndIf

TcQuery c_Qry New Alias "QRYCHV" 

//Posiciona no cabecalho da nota
If QRYCHV->(!Eof())

    //Monta XML dos itens
    c_XML := '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:urn="urn:workflow">' + c_EOL
    c_XML += '<soapenv:Header/>' + c_EOL
    c_XML += '<soapenv:Body>' + c_EOL
    c_XML += '    <urn:newChildEntityRecordList>' + c_EOL
    c_XML += '        <!--You may enter the following 4 items in any order-->' + c_EOL
    c_XML += '        <urn:WorkflowID>' + c_IDSE + '</urn:WorkflowID>' + c_EOL
    c_XML += '        <urn:MainEntityID>recebimentonfe</urn:MainEntityID>' + c_EOL
    c_XML += '        <urn:ChildRelationshipID>reldocorigreceb</urn:ChildRelationshipID>' + c_EOL
    c_XML += '        <urn:EntityRecordList>' + c_EOL

    While QRYCHV->(!Eof())

        c_XML += '            <!--Zero or more repetitions:-->' + c_EOL
        c_XML += '            <urn:EntityRecord>' + c_EOL
        c_XML += '            <!--Optional:-->' + c_EOL
        c_XML += '            <urn:EntityAttributeList>' + c_EOL
        c_XML += '                <!--Zero or more repetitions:-->' + c_EOL

        c_XML += '                <urn:EntityAttribute>' + c_EOL
        c_XML += '                  <urn:EntityAttributeID>numdocorigem</urn:EntityAttributeID>' + c_EOL
        c_XML += '                  <urn:EntityAttributeValue>' + QRYCHV->NOTA + '</urn:EntityAttributeValue>' + c_EOL
        c_XML += '                </urn:EntityAttribute>' + c_EOL

        c_XML += '                <urn:EntityAttribute>' + c_EOL
        c_XML += '                  <urn:EntityAttributeID>chavedocorigem</urn:EntityAttributeID>' + c_EOL
        c_XML += '                  <urn:EntityAttributeValue>' + QRYCHV->CHAVE + '</urn:EntityAttributeValue>' + c_EOL
        c_XML += '                </urn:EntityAttribute>' + c_EOL

        c_XML += '            </urn:EntityAttributeList>' + c_EOL
        c_XML += '            </urn:EntityRecord>' + c_EOL

        QRYCHV->(DbSkip())

    EndDo

    c_XML += '        </urn:EntityRecordList>' + c_EOL
    c_XML += '    </urn:newChildEntityRecordList>' + c_EOL
    c_XML += '</soapenv:Body>' + c_EOL
    c_XML += '</soapenv:Envelope>' + c_EOL

    //Grava Log do inicio
    n_RecLog := u_zWLZ3IncLOG("P", "newChildEntityRecordList", c_Url, "", c_XML, "SF2", c_ChvNFE, "WSSE011")

    //Executa WS dos Itens
    If o_Wsdl:SendSoapMsg(EncodeUTF8(c_XML))

        c_WSRet := o_Wsdl:GetSoapResponse()

        //Valida execucao
        If !Empty(c_WSRet) .And. ( !("FAULT" $ Upper(c_WSRet) .Or. "FAILURE" $ Upper(c_WSRet)) )

            o_Xml := XmlParser( c_WSRet, "_", @c_Error, @c_Warning )

            If o_Xml == NIL 

                l_Ret := .F.

            EndIf
        
        Else

        l_Ret := .F.

        EndIf
    
    
    Else

        //Não conseguiu retorno do XML
        c_WSRet := "Erro no retorno do XML, erro: " + o_Wsdl:cError
        l_Ret := .F.

    EndIf

    n_SeqFim  := Seconds()

    //Grava Log Final
    u_zWLZ4UpdLOG(n_RecLog, IIF(l_Ret,"1","2"), (n_SeqFim - n_SeqIni), c_WSRet, "", "SF2", c_ChvNFE, c_IDSE)

EndIf

Return l_Ret
 
 /***********************************************************************************************/
 
/* -------------------------------------------------------------
Funcao fClrGrid
Autor Felipe Azevedo dos Reis
Data 13/12/2018
Executa o metodo para excluir os dados da grid e não duplicar
------------------------------------------------------------- */

Static Function fClrGrid(c_ID, c_Entity, c_Child)

Local c_XML := ""

c_XML := '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:urn="urn:workflow">'
c_XML += '   <soapenv:Header/>'
c_XML += '   <soapenv:Body>'
c_XML += '      <urn:clearChildEntityRecord>'
c_XML += '         <!--You may enter the following 3 items in any order-->'
c_XML += '         <urn:WorkflowID>' + c_ID + '</urn:WorkflowID>'
c_XML += '         <urn:MainEntityID>' + c_Entity + '</urn:MainEntityID>'
c_XML += '         <urn:ChildRelationshipID>' + c_Child + '</urn:ChildRelationshipID>'
c_XML += '      </urn:clearChildEntityRecord>'
c_XML += '   </soapenv:Body>'
c_XML += '</soapenv:Envelope>'

//Executa o metodo, não tem gravação de log, por ser um processo terciário.
o_Wsdl:SendSoapMsg(EncodeUTF8(c_XML))

Return Nil

