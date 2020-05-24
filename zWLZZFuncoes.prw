#Include "Protheus.ch"
#Include "TopConn.ch"

User Function zWLZ0GetParamBD(c_Param)

Local a_AreaATU := GetArea()
Local l_Achou   := .F.

//Se não encontrar a chave, considera que é um ambiente de Teste
Local c_Ambiente    := Upper(AllTrim(GetSrvProfString("TipoAmbienteGDC", "TESTE"))) 
Local c_ChvAmb      := ""

If ( c_Ambiente == "PRODUCAO" )
    c_ChvAmb := "0" //0=Producao; 2=Ambos
Else
    c_ChvAmb := "1" //1=Teste; 2=Ambos
Endif

cAliasQry := GetNextAlias()

BeginSql Alias cAliasQry

    SELECT TOP 1 ZAP_FORFIL, ZAP.R_E_C_N_O_ AS RECZAP

    FROM %table:ZAP% ZAP

    WHERE ZAP_FILIAL = %xfilial:ZAP% 
    AND	ZAP_FORFIL IN ('  ', %Exp:cFilAnt%)   
    AND	ZAP_AMBIEN IN ('2', %Exp:c_ChvAmb%)
    AND ZAP_PARAM = %Exp:c_Param%
    AND	%notDel%
    ORDER BY 1 DESC

EndSql

(cAliasQry)->(DbGoTop())
If (cAliasQry)->(!Eof())
    l_Achou := .T.
    DbSelectArea("ZAP")
    DbGoTo((cAliasQry)->RECZAP)
EndIf
//Quando estou debugando, ao passar pela linha abaixo o debug simplesmente CAI
//(cAliasQry)->(DbCloseArea())

//Restaura a area de entrada apenas se o alias for diferente de ZAP
If ( a_AreaATU[1] <> "ZAP" )
    RestArea(a_AreaATU)
Endif

Return l_Achou

/***********************************************************************************************/

User Function zWLZ1fGetCpo(o_Json, c_Chave, c_Tipo, x_Default)

Local x_Cpo := Nil

If ( o_Json[c_Chave] == Nil )
    x_Cpo := x_Default
Else
    If ( c_Tipo == "D" )
        x_Cpo := U_zWLZ2DateAPI2ERP(o_Json[c_Chave], x_Default)
    Else
        x_Cpo := o_Json[c_Chave]
    Endif
Endif

Return x_Cpo 


/***********************************************************************************************/

User Function zWLZ2DateAPI2ERP(c_DateAPI, d_Default)

Local d_DateERP := d_Default

Local c_Ano := ""
Local c_Mes := ""
Local c_Dia := ""

If ( !Empty(c_DateAPI) )

    c_Ano := Left(c_DateAPI, 4)
    c_Mes := SubStr(c_DateAPI, 6, 2)
    c_Dia := SubStr(c_DateAPI, 9, 2)

    d_DateERP := STOD(c_Ano+c_Mes+c_Dia)

EndIf

Return d_DateERP


/***********************************************************************************************/

User Function zWLZ3IncLOG(c_Orig, c_Servic, c_URL, c_Verbo, c_Request, c_Tabela, c_Chave, c_Rotina)

Default c_Request   := ""
Default c_Tabela    := ""
Default c_Chave     := ""
Default c_Rotina    := ""

DbSelectArea("ZAL")
RecLock("ZAL", .T.)
Replace ZAL_FILIAL With xFilial("ZAL")
Replace ZAL_STATUS With "0"             //(0=Processando; 1=OK; 2=ERRO)
Replace ZAL_ORIGEM With c_Orig          //(P=PROTHEUS; W=Weblayer)
Replace ZAL_DTINIC With MsDate()        //(Data de Inicio do Processo)
Replace ZAL_HRINIC With Time()          //(Hora de Inicio do Processo)
Replace ZAL_METODO With c_Verbo         //(Verbo da Método)
Replace ZAL_URL    With c_URL           //(URL da API)
Replace ZAL_SERVIC With c_Servic        //(Nome do Serviço)
Replace ZAL_REQUES With c_Request       //(Request feito)
Replace ZAL_TABERP With c_Tabela        //(Alias da interação)
Replace ZAL_CHVERP With c_Chave         //(Chave única do Alias)
Replace ZAL_FUNORI With c_Rotina        //(Rotina que esta sendo executada)
MsUnLock()

Return ZAL->(Recno())

/***********************************************************************************************/

User Function zWLZ4UpdLOG(n_RecLog, c_Status, n_Durac, c_Response, c_StCode, c_Tabela, c_Chave, c_ChvTer)

Default n_RecLog    := 0
Default n_Durac     := 0
Default c_Response  := ""
Default c_StCode    := ""
Default c_Tabela    := ""
Default c_Chave     := ""
Default c_ChvTer    := ""

DbSelectArea("ZAL")
If ( n_RecLog > 0 )
    DbGoTo(n_RecLog)
    RecLock("ZAL", .F.)
    Replace ZAL_STATUS With c_Status        //(0=Processando; 1=OK; 2=ERRO)
    Replace ZAL_TMPDUR With n_Durac         //(Tempo de Duracao em milesegundos)
    Replace ZAL_RESPON With c_Response      //(Response retornado)
    Replace ZAL_STCODE With c_StCode        //(Status Code retornado)
    Replace ZAL_TABERP With c_Tabela        //(Alias da interação)
    Replace ZAL_CHVERP With c_Chave         //(Chave única do Alias)
    Replace ZAL_CHVTER With c_ChvTer        //(Chave única do Sistema Terceiro)
    MsUnLock()
Endif

Return Nil

/***********************************************************************************************/