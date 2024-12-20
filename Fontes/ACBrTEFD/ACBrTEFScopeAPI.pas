{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2024 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo:                                                 }
{                                                                              }
{  Voc� pode obter a �ltima vers�o desse arquivo na pagina do  Projeto ACBr    }
{ Componentes localizado em      http://www.sourceforge.net/projects/acbr      }
{                                                                              }
{  Esta biblioteca � software livre; voc� pode redistribu�-la e/ou modific�-la }
{ sob os termos da Licen�a P�blica Geral Menor do GNU conforme publicada pela  }
{ Free Software Foundation; tanto a vers�o 2.1 da Licen�a, ou (a seu crit�rio) }
{ qualquer vers�o posterior.                                                   }
{                                                                              }
{  Esta biblioteca � distribu�da na expectativa de que seja �til, por�m, SEM   }
{ NENHUMA GARANTIA; nem mesmo a garantia impl�cita de COMERCIABILIDADE OU      }
{ ADEQUA��O A UMA FINALIDADE ESPEC�FICA. Consulte a Licen�a P�blica Geral Menor}
{ do GNU para mais detalhes. (Arquivo LICEN�A.TXT ou LICENSE.TXT)              }
{                                                                              }
{  Voc� deve ter recebido uma c�pia da Licen�a P�blica Geral Menor do GNU junto}
{ com esta biblioteca; se n�o, escreva para a Free Software Foundation, Inc.,  }
{ no endere�o 59 Temple Street, Suite 330, Boston, MA 02111-1307 USA.          }
{ Voc� tamb�m pode obter uma copia da licen�a em:                              }
{ http://www.opensource.org/licenses/lgpl-license.php                          }
{                                                                              }
{ Daniel Sim�es de Almeida - daniel@projetoacbr.com.br - www.projetoacbr.com.br}
{       Rua Coronel Aureliano de Camargo, 963 - Tatu� - SP - 18270-170         }
{******************************************************************************}

{$I ACBr.inc}

unit ACBrTEFScopeAPI;

interface

uses
  Classes, SysUtils;

{------------------------------------------------------------------------------
  DECLARACAO DE CONSTANTES GLOBAIS
------------------------------------------------------------------------------}
const
  {$IFDEF MSWINDOWS}
   CScopeLib = 'scopeapi.dll';
  {$ELSE}
   CScopeLib = 'libScopeApi.so';
  {$ENDIF}

  CScopeINi = 'scope.ini';

resourcestring
  sErrLibJaInicializda = 'Biblioteca ScopeAPI j� foi inicializada';
  sErrDirTrabalhoInvalido = 'Diret�rio de Trabalho n�o encontrado: %s';
  sErrScopeINIInvalido = 'Arquivo de Configura��o ' + CScopeINI + ' n�o encontrado em: %s';
  sErrEndServNaoEncontrado = 'Endere�o do Servidor n�o encontrado em '+CScopeINi;
  sErrEndServNaoInformado = 'Endere�o do Servidor n�o informada em "EnderecoIP"';
  sErrPortServNaoInformado = 'Porta do Servidor n�o informada em "PortTCP"';
  sErrNaoConectado = 'N�o conectado ao Servidor Scope';
  sErrSemSessao = 'Sess�o TEF n�o foi aberta';
  sErrEventoNaoAtribuido = 'Evento %s n�o atribuido';
  sErrTransacaoNaoIniciada = 'Transa��o n�o foi iniciada';
  sErrTransacaoJaIniciada = 'Transa��o j� foi iniciada';

  sMsgAbrindoConexao = 'Abrindo comunica��o...'+sLineBreak+'Empresa: %s, Filial %s';
  sMsgConctadoAoServidor = 'Conectado Scope em: %s';
  sMsgDesconectado = 'Desconectado Scope';
  sMsgInicioSessaoTEF = 'Iniciando sess�o TEF';
  sMsgTransacaoEmAndamento = 'Transa��o em Andamento %s';
  sMsgTransacaoCompleta = 'Transa��o Completa';
  sMsgTransacaoDesfeita = 'A TRANSA��O TEF ANTERIOR FOI DESFEITA.'+sLineBreak+'RETER O CUPOM TEF.';

const
  CINTERVALO_COLETA = 200;


  {--------------------------------------------------------------------------------------------
  		 Codigos/erros devolvidos pelo Scope
  --------------------------------------------------------------------------------------------}
  RCS_SUCESSO                                 = $0000;

  RCS_COD_AUTORIZADORA_NAO_NUMERICO           = $0100;
  RCS_ALC_RESTRICAO_CLIENTE                   = $0101;
  RCS_ALC_JACONSULTOU_BANCOAG_IGUAIS          = $0102;
  RCS_ALC_JACONSULTOU_BANCOAG_DIFERENTES      = $0103;
  RCS_COD_GAR_NAO_AUTORIZADA                  = $0104;
  RCS_COMPRE_SAQUE_APROVADO_PARCIAL           = $0105;
  RCS_VOUCHER_APROVADO_PARCIAL                = $0106;
  RCS_APROVADO_COM_PREMIO                     = $0107;

  RCS_AUTO_ERRO_CRD_RLV_INVALIDO              = $F900;
  RCS_AUTO_ERRO_CRD_TRK_INVALIDA              = $F901;
  RCS_AUTO_ERRO_CRD_INVALIDO                  = $F902;
  RCS_AUTO_ERRO_CRD_VALIDADE                  = $F903;
  RCS_AUTO_ERRO_PARM_INVALIDO                 = $F904;

  RCS_ERRO_PARM_1                             = $FA01;
  RCS_ERRO_PARM_2                             = $FA02;
  RCS_ERRO_PARM_3                             = $FA03;
  RCS_ERRO_PARM_4                             = $FA04;
  RCS_ERRO_PARM_5                             = $FA05;

  RCS_THREAD_API_NOT_INIT                     = $FB01;
  RCS_ERRO_CRIA_SERV                          = $FB02;
  RCS_ERRO_CRITICA_MSG                        = $FB03;
  RCS_ERRO_MONTA_MSG                          = $FB04;
  RCS_ERRO_ARQ_TEF                            = $FB05;
  RCS_ERRO_CONTEXTO_TEF                       = $FB06;
  RCS_ERRO_TOTAL_TEF                          = $FB07;
  RCS_ERRO_ARQ_CICLO_TEF                      = $FB08;
  RCS_ERRO_NUM_MAX_TEF_SESSAO                 = $FB09;
  RCS_ERRO_MONTANDO_CONFIRMACAO               = $FB0A;
  RCS_ERRO_MONTANDO_DESFAZIMENTO              = $FB0B;
  RCS_ERRO_CRIPTOGRAFIA                       = $FB0C;

  RCS_PRIMEIRO_COLETA_DADOS                   = $FC00;
  RCS_COLETAR_CARTAO                          = $FC00;

  RCS_MOSTRA_INFO_AGUARDA_CONF                = $FCFF;
  RCS_ULTIMO_COLETA_DADOS                     = $FCFF;

  RCS_TRN_EM_ANDAMENTO                        = $FE00;
  RCS_API_NAO_INICIALIZADA                    = $FE01;
  RCS_API_JA_INICIALIZADA                     = $FE02;
  RCS_EXISTE_TRN_SUSPENSA                     = $FE03;
  RCS_NAO_EXISTE_TRN_SUSPENSA                 = $FE04;
  RCS_API_NAO_FEZ_TRN                         = $FE05;
  RCS_POS_JA_LOGADO                           = $FE06;
  RCS_PROTOCOLO_NAO_SUPORTADO                 = $FE07;
  RCS_POS_NAO_CADASTRADO                      = $FE08;
  RCS_SRV_NOT_CFG                             = $FE09;
  RCS_NAO_HA_PDVS_DISPONIVEIS                 = $FE0A;
  RCS_PROTOCOLO_INCOMPATIVEL                  = $FE0B;
  RCS_NAO_PODE_DESFAZER_TRN_ENCERRADA         = $FE0C;
  RCS_NAO_HA_CAMPOS_SALVOS                    = $FE0D;

  RCS_SERVER_OFF                              = $FF00;
  RCS_ACQUIRER_OFF                            = $FF01;
  RCS_CANCELADA_PELO_OPERADOR                 = $FF02;
  RCS_BIN_SERV_INV                            = $FF03;
  RCS_TRN_JA_CANCELADA                        = $FF04;
  RCS_TRN_NOT_FOUND_BD                        = $FF05;
  RCS_TRN_NAO_REVERSIVEL                      = $FF06;
  RCS_PARMS_INCOMPATIVEIS                     = $FF07;
  RCS_ERRO_BD                                 = $FF08;
  RCS_TIMEOUT_BD                              = $FF09;
  RCS_BD_OFFLINE                              = $FF0A;
  RCS_ABORTADA_PELO_APLICATIVO                = $FF0B;
  RCS_TRN_NAO_IMPLEMENTADA                    = $FF0C;
  RCS_HANDLE_INVALIDO                         = $FF0D;
  RCS_TX_SERV_INVALIDA                        = $FF0E;
  RCS_TX_SERV_EXCEDE_LIM                      = $FF0F;
  RCS_DADO_INVALIDO                           = $FF10;
  RCS_NAO_EXITE_CUPOM_VALIDO                  = $FF11;
  RCS_AREA_RESERVADA_INSUFICIENTE             = $FF12;
  RCS_ERRO_LIMITE                             = $FF13;
  RCS_TRN_DESFEITA                            = $FF14;
  RCS_DIGITACAO_NAO_PERMITIDA                 = $FF15;
  RCS_MEMORIA_INSUFICIENTE                    = $FF16;
  RCS_SERVICE_CODE_INVALIDO                   = $FF17;
  RCS_DATA_INVALIDA                           = $FF18;
  RCS_CARTAO_VENCIDO                          = $FF19;
  RCS_CARTAO_INVALIDO                         = $FF1A;
  RCS_DESFAZIMENTO_NAO_DISPONIVEL             = $FF1B;
  RCS_ERRO_IMPRESSAO_CUPOM                    = $FF1C;
  RCS_SESSAO_MTEF_EM_ANDAMENTO                = $FF1D;
  RCS_TRANSACAO_JA_EFETUADA                   = $FF1E;
  RCS_INSERIR_CARTAO_CHIP                     = $FF1F;
  RCS_CONTROLE_OBRIGATORIO                    = $FF20;
  RCS_PRE_AUTORIZACAO_OBRIGATORIA             = $FF21;
  RCS_SERVICO_NAO_CONFIGURADO                 = $FF22;
  RCS_SERVICO_NAO_DEFINIDO                    = $FF23;
  RCS_NUM_PARCELAS_INVALIDAS                  = $FF24;
  RCS_VALOR_INVALIDO                          = $FF25;
  RCS_BIN_SERV_INV_VISANET                    = $FF26;
  RCS_ESTADO_NAO_DEFINIDO                     = $FF27;
  RCS_OPERACAO_NAO_PERMITIDA                  = $FF28;
  RCS_CNPG_CPF_INVALIDO                       = $FF29;
  RCS_ERRO_DAC_BLK1                           = $FF2A;
  RCS_ERRO_DAC_BLK2                           = $FF2B;
  RCS_ERRO_DAC_BLK3                           = $FF2C;
  RCS_ERRO_DAC_BLK4                           = $FF2D;
  RCS_AID_INVALIDO                            = $FF2E;
  RCS_DISPONIVEL2                             = $FF2F;
  RCS_AUT_RETORNOU_DADOS_INVALIDOS            = $FF30;
  RCS_CONTA_NAO_PERMITIDA                     = $FF31;
  RCS_CONTA_VENCIDA                           = $FF32;
  RCS_NAO_EXISTE_RESUMO                       = $FF33;
  RCS_CODBAR_INVALIDO                         = $FF34;
  RCS_ERRO_DAC                                = $FF35;
  RCS_ERRO_FINALIZACAO_TRN_ANTERIOR           = $FF36;
  RCS_SERVICO_INVERTIDO                       = $FF37;
  RCS_CARTAO_NAO_PERMITIDO                    = $FF38;
  RCS_SCPC_CPF_ONLY                           = $FF39;
  RCS_ERRO_INTERNO_EXECUCAO_COLETA            = $FF3A;
  RCS_LISTA_NAO_DISPONIVEL                    = $FF3B;
  RCS_ERRO_LEITURA_CARTAO                     = $FF3C;
  RCS_CONTROLE_INVALIDO                       = $FF3D;
  RCS_ERRO_AO_ENVIAR_MSG_SERVIDOR             = $FF3E;
  RCS_INTERFACE_SAB_NAO_INICIALIZADA          = $FF3F;
  RCS_ERRO_DADOS_AINDA_NAO_DISPONIVEIS        = $FF40;
  RCS_ERRO_DADOS_INDISPONIVEIS                = $FF41;
  RCS_SERVIDOR_SAB_OFF                        = $FF42;
  RCS_ERRO_CONEXAO_SCOPE_E_SAB                = $FF43;
  RCS_ERRO_NSU_RECEBIDO                       = $FF44;
  RCS_ERRO_LOGON_PDV                          = $FF45;
  RCS_ERRO_PROCESSAMENTO_CHIP                 = $FF46;
  RCS_OPERADORA_INVALIDA                      = $FF47;
  RCS_DADOS_RECARGA_NAO_ENCONTRADOS           = $FF48;
  RCS_CANCELADA_PELO_CLIENTE                  = $FF49;
  RCS_APROVADA_OFFLINE                        = $FF50;
  RCS_VERSAO_BD_INCOMPATIVEL                  = $FF51;
  RCS_FORA_PRAZO                              = $FF52;
  RCS_MENSAGEM_INVALIDA                       = $FF53;
  RCS_PINPAD_AINDA_NAO_FOI_ABERTO             = $FF54;
  RCS_PINPAD_JA_FOI_ABERTO                    = $FF55;
  RCS_ESTADO_INVALIDO                         = $FF56;
  RCS_PP_COMPARTILHADO_NAO_CONFIGURADO        = $FF57;
  RCS_PP_COMPARTILHADO_NAO_TRABALHA_VISA2000  = $FF58;
  RCS_USO_EXCLUSIVO_INTERFACE_COLETA          = $FF59;
  RCS_AREA_ATRIBUTOS_SERV_INSUFICIENTE        = $FF5A;
  RCS_SCOPE_CONFIGURADO_PP_COMPARTILHADO      = $FF5B;
  RCS_SCOPE_NAO_CONFIGURADO_PP_COMPARTILHADO  = $FF5C;
  RCS_ERRO_ABERTURA_PERIFERICO                = $FF5D;
  RCS_ERRO_DESMONTA_ISO                       = $FF5E;
  RCS_BANDEIRA_NAO_CONFIGURADA                = $FF5F;
  RCS_FUNCAO_NAO_DISPONIVEL                   = $FF60;
  RCS_VALOR_MIN_PARC_INVALIDO                 = $FF61;
  RCS_VALOR_NAO_DISPONIVEL                    = $FF62;
  RCS_NUMTEL_INVALIDO                         = $FF63;
  RCS_DDD_INVALIDO                            = $FF64;
  RCS_ERRO_REDE_MODELO_2                      = $FF65;
  RCS_ERRO_REDE_MODELO_3                      = $FF66;
  RCS_PROMPTS_NAO_ENCONTRADOS                 = $FF67;
  RCS_USE_REIMPRESSAO_OFFLINE                 = $FF68;
  RCS_CONTRATO_SUSPENSO                       = $FF69;
  RCS_PERMITE_SOMENTE_DIGITADO                = $FF6A;
  RCS_NOT_FOUND                               = $FF6B;
  RCS_CODEAN128_INVALIDO                      = $FF6C;
  RCS_MOBILE_NAO_PERMITIDA                    = $FF6D;
  RCS_ACQUIRER_TIMEOUT                        = $FF6E;
  RCS_ERRO_ARQ_CONTEXTO                       = $FF6F;
  RCS_PLACA_INVALIDA                          = $FF70;
  RCS_CONSULTA_BRADESCO_NAO_HABILITADA        = $FF71;
  RCS_CODIGO_BANDEIRA_MAIOR_255               = $FF72;
  RCS_REDE_INICIANDO                          = $FF73;
  RCS_PINPAD_NAO_SUPORTADO_PERFIL             = $FF74;
  RCS_ERRO_ESTATISTICA_REDECARD               = $FF75;
  RCS_PINPAD_TABELAS_VAZIAS                   = $FF76;
  RCS_ERRO_CONFIG_PDV                         = $FF96;

  RCS_ERRO_GENERICO                           = $FFFF;


  {--------------------------------------------------------------------------------------------
  		 Define as teclas que podem ser habilitadas
  --------------------------------------------------------------------------------------------}
  T_CANCELA = $01;
  T_PROXIMO = $02;
  T_RETORNA = $04;


  {--------------------------------------------------------------------------------------------
  		 Codigos devolvidos pelas funcoes de acesso ao PIN-Pad Compartilhado
  --------------------------------------------------------------------------------------------}
  PC_OK                       = 0; // Operacao efetuada com sucesso - parametros de retorno(OUTPUT) contem dados validos.
  PC_PROCESSING               = 1; // Em processamento. Deve-se chamar a funcao novamente ou PC_Abort para finalizar.
  PC_NOTIFY                   = 2; // Em processamento. Deve-se apresentar no "checkout" uma mensagem retornada pela funcao e chama-la novamente ou PC_Abort para finalizar.
  PC_F1                       = 4; // Pressionada tecla de funcao #1.
  PC_F2                       = 5; // Pressionada tecla de funcao #2.
  PC_F3                       = 6; // Pressionada tecla de funcao #3.
  PC_F4                       = 7; // Pressionada tecla de funcao #4.
  PC_BACKSP                   = 8; // Pressionada tecla de apagar (backspace)

  // Status de 10 a 29 : Erros basicos da biblioteca
  PC_INVCALL                  = 10; // Chamada invalida ? funcao. Operacoes previas sao necessarias.
  PC_INVPARM                  = 11; // Parametro invalido passado a funcao.
  PC_TIMEOUT                  = 12; // Esgotado o tempo maximo estipulado para a operacao.
  PC_CANCEL                   = 13; // Operacao cancelada pelo operador.

  PC_ALREADYOPEN              = 14; // Pinpad ja aberto.
  PC_NOTOPEN                  = 15; // Pinpad nao foi aberto.
  PC_EXECERR                  = 16; // Erro interno de execucao - problema de implementao da biblioteca (software).
  PC_INVMODEL                 = 17; // Funcao nao suportada pelo modelo de pinpad.
  PC_NOFUNC                   = 18; // Funcao nao disponivel na Biblioteca do pinpad.
  PC_ERRMANDAT                = 19; // Ausencia de dado mandatorio para o processamento.
  PC_TABEXP                   = 20; // Tabelas expiradas (pelo "time-stamp").
  PC_TABERR                   = 21; // Erro ao tentar gravar tabelas (falta de espaco, por exemplo)
  PC_NOAPPLIC                 = 22; // Aplicacao da rede adquirente nao existe no pinpad.

  // 23 a 29 Reservado para uso futuro
  // Status de 30 a 39 : Erros de comunicacao/protocolo com o pinpad
  PC_PORTERR                  = 30; // Erro de comunicacao: porta serial do pinpad provavelmente ocupada.
  PC_COMMERR                  = 31; // Erro de comunicacao: pinpad provavelmente desconectado ou problemas com a interface serial.
  PC_UNKNOWNSTAT              = 32; // Status informado pelo pinpad nao e conhecido.
  PC_RSPERR                   = 33; // Mensagem recebida do pinpad possui formato invalido.
  PC_COMMTOUT                 = 34; // Tempo esgotado ao esperar pela resposta do pinpad (no caso decomandos nao blocantes).

  // 35 a 39 Reservado para uso futuro
  // Status de 40 a 49 : Erros b?sicos reportados pelo pinpad
  PC_INTERR                   = 40; // Erro interno do pinpad.
  PC_MCDATAERR                = 41; // Erro de leitura do cartao magnetico.
  PC_ERRPIN                   = 42; // Erro na captura do PIN - Master Key pode nao estar presente.
  PC_NOCARD                   = 43; // Nao ha cartao inteligente presente no acoplador.
  PC_PINBUSY                  = 44; // Pinpad nao pode processar a captura de PIN temporariamente devido a questoes de seguranca (como quando e atingido o limite de capturas dentro de um intervalo de tempo).

  // 45 a 49 Reservado para uso futuro.
  // Status de 50 a 59 : Erros de processamento de cart?o com chip (SAM)
  PC_SAMERR                   = 50; // Erro generico no modulo SAM.
  PC_NOSAM                    = 51; // SAM ausente, "mudo", ou com erro de comunicacao.
  PC_SAMINV                   = 52; // SAM invalido, desconhecido ou com problemas.

  // 53 a 59 Reservado para uso futuro.
  // Status de 60 a 99 : Erros de processamento de cartao com chip (usuario)
  PC_DUMBCARD                 = 60; // Cartao nao responde ("mudo") ou chip nao presente.
  PC_ERRCARD                  = 61; // Erro de comunica??o do pinpad com o cart?o inteligente.
  PC_CARDINV                  = 62; // Cartao do tipo invalido ou desconhecido, nao pode ser tratado (nao EMV nem TIBC v1).
  PC_CARDBLOCKED              = 63; // Cartao bloqueado por numero excessivo de senhas incorretas (somente para Easy-Entry TIBC v1).
  PC_CARDNAUTH                = 64; // Cartao TIBC v1 nao autenticado pelo modulo SAM (somente para Easy-Entry TIBC v1).
  PC_CARDEXPIRED              = 65; // Cartao TIBC v1 expirado (somente para Easy-Entry TIBC v1).
  PC_CARDERRSTRUCT            = 66; // Cartao com erro de estrutura - arquivos estao faltando.
  PC_CARDINVALIDAT            = 67; // Cartao foi invalidado.
                                    // Se o cartao for TIBC v1, quando selecao de arquivo ou ATR retornar status 6284.
                                    // Se o cartao for EMV, quando selecao de aplicacao retornar status 6A81.
  PC_CARDPROBLEMS             = 68;  // Cartao com problemas. Esse status e valido para muitas
                                     // ocorrencias no processamento de cartoes TIBC v1 e EMV onde o
                                     // cartao nao se comporta conforme o esperado e a transacao deve ser finalizada.
  PC_CARDINVDATA              = 69; // O cartao, seja TIBC v1 ou EMV, comporta-se corretamente porem possui dados invalidos ou inconsistentes.
  PC_CARDAPPNAV	              = 70; // Cartao sem nenhuma aplicacao disponivel para as condicoes pedidas (ou cartao e reconhecido como TIBC v1 ou EMV mas nao
                                    // possui nenhuma aplicacao compativel com a requerida).
  PC_CARDAPPNAUT              = 71; // Somente para cartao EMV. A aplicacao selecionada nao pode ser
                                    // utilizada neste terminal pois o Get Processing Options retornou status 6985.
  PC_NOBALANCE                = 72; // Somente para aplicacao de moedeiro. O saldo do moedeiro e insuficiente para a operacao.
  PC_LIMITEXC                 = 73; // Somente para aplicacao de moedeiro. O limite maximo para a operacao foi excedido.
  PC_CARDNOTEFFECT            = 74; // Cartao ainda nao efetivo.
  PC_VCINVCURR                = 75; // Moeda ?nv?lida.
  PC_ERRFALBACK               = 76; // Erro de alto nivel no cartao EMV que e passivel de Fallback.

  // 77 a 99 Reservado para uso futuro.
   // 200 a 299 Reservado para uso do Scope
  PC_RESERVADO                = 200; // Transacao negada na funcao PP_GoOnChip()
  PC_TRN_NEGADA_CHIP          = 201; // Transacao negada na funcao PP_GoOnChip()
  PC_MEM_NAO_ALOCADA          = 202; // Memoria nao alocada para a estrutura do pinpad compartilhado
  PC_ERRO_ALOCANDO_MEMORIA    = 203; // Erro alocando memoria
  PC_MEMORIA_INSUFICIENTE     = 204; // Memoria insuficiente para receber os dados
  PC_JA_ABERTO_VIA_SCOPE      = 205; // Pinpad ja aberto via Scope
  PC_MKEY_NAO_DEFINIDA        = 206; // Nao foi possivel definir a Master Key a ser utilizada
  PC_ESTADO_NAO_DEFINIDO      = 207; // Nao foi possivel definir o Estado de coleta no PIN-Pad
  PC_ERRO_PRM_GET_PIN         = 208; // Erro no parametro da funcao GetPIN
  PC_PINPAD_NAO_CONFIGURADO   = 209; // Pinpad nao configurado
  PC_DISPLAY_NAO_PERMITIDO    = 210; // Display nao permitido neste momento ou situacao
  PC_NAO_ABERTO_APP           = 211; // Pinpad nao foi aberto pela aplicacao
  PC_TIMEOUT_USER             = 212; // Timeout do cliente/usuario
  PC_DATA_NOT_FOUND           = 213; // Dado no chip nao encontrado

  PC_COMANDA_VAZIA            = 214; // Comanda nao possui itens
  PC_COMANDA_INVALIDA         = 215; // A Leitura da comanda apresentou erros
  PC_PINPAD_TABELAS_VAZIAS    = 216; // As tabelas do pinpad estao vazias

  // 213 a 299 Reservado para uso futuro.
  PC_MAX_ERRO                 = 300; // Indica o fim da tabela de erros

  {--------------------------------------------------------------------------------------------
  		Tipo de aplicacao do PIN-Pad Compartilhado
  --------------------------------------------------------------------------------------------}
  PC_APL_CREDITO  = 1; // Aplicacao de Credito
  PC_APL_DEBITO	  = 2; // Aplicacao de Debito
  PC_APL_QUALQUER = 99; // Qualquer aplicacao


  {--------------------------------------------------------------------------------------------
  		Retornos do Par�metro "Config" do m�todo "ScopeConsultaPP"
  --------------------------------------------------------------------------------------------}
  PPCONF_MODO_NONE    = 0;    // Pinpad
  PPCONF_MODO_COMPART = 1;    // Pinpad compartilhado
  PPCONF_MODO_ABECS   = 2;    // Pinpad ABECS

  {--------------------------------------------------------------------------------------------
  		Valores v�lidos para Par�metro "Canal" do m�todo "ScopePPOpenSecure"
  --------------------------------------------------------------------------------------------}
  CANAL_COMM_NONE      = 0;  // Conforme configuracao do scope.ini
  CANAL_COMM_SERIAL    = 1;  // Comunicacao serial
  CANAL_COMM_USB       = 2;  // Comunicacao USB
  CANAL_COMM_BLUETOOTH = 3;  // Comunicacao Bluetooth


  {--------------------------------------------------------------------------------------------
  		Valores v�lidos para Par�metro "id" do m�todo "ScopeConfigura"
  --------------------------------------------------------------------------------------------}
  CFG_CANCELAR_OPERACAO_PINPAD     = 1;   // Permite cancelar a interacao (leitura do cartao, senha e ...) no pinpad (default: desabilitado)
  CFG_OBTER_SERVICOS               = 2;   // Permite retornar o estado TC_OBTEM_SERVICOS durante o fluxo de TEF (default: desabilitado)
  CFG_NAO_ABRIR_DIGITADO_COM_PP    = 4;   // Permite nao abrir o digitado na leitura do cartao com o PP Compartilhado (default: desabilitado)
  CFG_DEVOLVER_SENHA_CRIPTOGRAFADA = 8;   // Permite devolver a senha criptografada com a master key da Itautec (default: desabilitado, ou seja, devolve senha aberta)
  CFG_IMPRESSORA_CARBONADA         = 16;  // Permite configurar a impressora como carbonada para nao imprimir 2a via... (default: desabilitado, ou seja, no cupom exibira 1a e 2a via)
  CFG_ARMAZENA_EM_QUEDA            = 32;  // Armazena dados da coleta para recuperar em queda de energia. (default: desabilitado)
  CFG_MASCARAR_DADOS               = 64;  // Configura se mascaramento de dados pelo ObtemCampo esta habilitado. (default: habilitado)
  CFG_ATUALIZA_TRANSACAO_EM_QUEDA  = 128; // Permite confirmar/desfazer a transacao em caso de queda de energia. (default: desabilitado, ou seja, sempre desfazer)
  CFG_PERMITIR_SAQUE               = 256; // Habilita coleta de saque em operacoes de Debito A Vista da rede Cielo
  CFG_COLETA_RECARGA_PP	           = 512; // Permite desabilitar a coleta do ddd e telefone no pinpad em recarga de celular (default: conforme configuracao do SCOPECNF)

  {--------------------------------------------------------------------------------------------
  		Valores v�lidos para Par�metro "Param" do m�todo "ScopeConfigura"
  --------------------------------------------------------------------------------------------}
  OP_DESABILITA	  = 0;
  OP_HABILITA     = 1;
  OP_SOMENTE_PCI  = 2;

  {--------------------------------------------------------------------------------------------
  		Define os estados para a interface coleta
  --------------------------------------------------------------------------------------------}
  TC_CARTAO                          = $FC00;
  TC_VALIDADE_CARTAO                 = $FC01;
  TC_IMPRIME_CUPOM                   = $FC02;
  TC_CPF_CGC                         = $FC03;
  TC_BANCO                           = $FC04;
  TC_AGENCIA                         = $FC05;
  TC_NUMERO_CHEQUE                   = $FC06;
  TC_BOM_PARA                        = $FC07;
  TC_IMPRIME_CHEQUE                  = $FC08;
  TC_DECIDE_AVISTA                   = $FC09;
  TC_DECIDE_P_ADM_EST                = $FC0A;
  TC_DECIDE_P_DATADO                 = $FC0B;
  TC_DECIDE_P_AVISTA                 = $FC0C;
  TC_DECIDE_D_E_PARC                 = $FC0D;
  TC_QTDE_PARCELAS                   = $FC0E;
  TC_DECIDE_P_FINANC                 = $FC0F;
  TC_DIA_MES                         = $FC10;
  TC_SENHA                           = $FC11;
  TC_CONTROLE                        = $FC12;
  TC_FORMA_PAGAMENTO                 = $FC13;
  TC_PRIMEIRO_VENCIMENTO             = $FC14;
  TC_VALOR_ENTRADA                   = $FC15;
  TC_FORMA_ENTRADA                   = $FC16;
  TC_CONTA_CORRENTE                  = $FC17;
  TC_ULTIMOS_DIGITOS                 = $FC18;
  TC_REIMPRESSAO_COMPROVANTE         = $FC19;
  TC_DECISAO_C_PARC                  = $FC1A;
  TC_IMPRIME_CONSULTA                = $FC1B;
  TC_DECISAO_CONT                    = $FC1C;
  TC_DECIDE_ULTIMO                   = $FC1D;
  TC_NUMERO_CHEQUE_CDC               = $FC1E;
  TC_QTD_DIAS                        = $FC1F;
  TC_NUM_PRE_AUTORIZACAO             = $FC20;
  TC_DIA_MES_FECHADO                 = $FC21;
  TC_IMPRIME_NOTA_PROMISSORIA        = $FC22;
  TC_CEP                             = $FC23;
  TC_NUMERO_ENDERECO                 = $FC24;
  TC_COMPLEMENTO                     = $FC25;
  TC_PLANO_PAGAMENTO                 = $FC26;
  TC_CICLOS_A_PULAR                  = $FC27;
  TC_NRO_ITEM                        = $FC28;
  TC_CVV_CVC_2                       = $FC29;
  TC_AUSENCIA_CVV_CVC_2              = $FC2A;
  TC_DECIDE_GARANTIA                 = $FC2B;
  TC_DECIDE_RISCO                    = $FC2C;
  TC_COLETA_VALOR_SAQUE              = $FC2D;
  TC_COLETA_VALOR_RECARGA            = $FC2E;
  TC_COLETA_COD_LOC_TELEFONE         = $FC2F;
  TC_COLETA_NUM_TELEFONE             = $FC30;
  TC_COLETA_DIG_VERIFICADOR          = $FC31;
  TC_COLETA_DDMMAA                   = $FC32;
  TC_COLETA_VALOR_TX_SERVICO         = $FC33;
  TC_COLETA_VALOR                    = $FC34;
  TC_DECIDE_SAQUE                    = $FC35;
  TC_DECIDE_SAQUE_SIMULADO           = $FC36;
  TC_DECIDE_SALDO_EXTRATO            = $FC37;
  TC_DECIDE_RESUMIDO_SEGVIA          = $FC38;
  TC_DECIDE_CONSULTA_RESGATE         = $FC39;
  TC_COLETA_NSU_HOST                 = $FC3A;
  TC_COLETA_SERVICO                  = $FC3B;
  TC_COLETA_COD_REDE                 = $FC3C;

  TC_DECIDE_RESGATE_AVULSO           = $FC40;
  TC_COLETA_DDMMAAAA                 = $FC41;
  TC_COLETA_AUT_MEDICAMENTO          = $FC42;
  TC_COLETA_REG_MEDICAMENTO          = $FC43;
  TC_DISP_LISTA_MEDICAMENTO          = $FC44;
  TC_EXIBE_MSG                       = $FC45;
  TC_IMPRIME_CUPOM_PARCIAL           = $FC46;
  TC_COLETA_QTD_PARC_ACEITA1         = $FC47;
  TC_COLETA_COD_BARRAS               = $FC48;
  TC_COLETA_COD_CONSULTA_PBM         = $FC49;
  TC_COLETA_CRM_MEDICO               = $FC4A;
  TC_COLETA_COD_UF_CRM_MEDICO        = $FC4B;
  TC_COLETA_SEGURO                   = $FC4C;
  TC_DECIDE_CARTAO                   = $FC4D;
  TC_COLETA_DADOS_TOKORO             = $FC4E;
  TC_DECIDE_PAG_APOS_VENC            = $FC4F;
  TC_COLETA_DECIDE_COL_SENHA         = $FC50;
  TC_IMPRIME_CUPOM_PROMOCIONAL       = $FC51;
  TC_COLETA_UTILIZA_SALDO            = $FC52;
  TC_COLETA_CODIGO_MATERIAL          = $FC53;
  TC_COLETA_PLANO                    = $FC54;
  TC_DECIDE_PAGTO_CHEQUE             = $FC55;
  TC_DECIDE_CONFIRMA_TRN             = $FC56;
  TC_DECIDE_PAGTO_ROTATIVO           = $FC57;
  TC_COLETA_CMC7                     = $FC58;
  TC_DECIDE_DIN_TEF                  = $FC59;
  TC_COLETA_TEF_EXT_COD_GRUPO        = $FC5A;
  TC_COLETA_TEF_EXT_COD_REDE         = $FC5B;
  TC_COLETA_TEF_EXT_COD_ESTAB        = $FC5C;
  TC_COLETA_TEF_EXT_NSU_HOST         = $FC5D;
  TC_COLETA_TEF_EXT_DDMMAAAA         = $FC5E;
  TC_DECIDE_CONSULTA                 = $FC5F;
  TC_CONTA_PERMITIDA_CONTINUA        = $FC60;
  TC_COLETA_COD_BANDEIRA             = $FC61;
  TC_DECIDE_CONTA_FATURA             = $FC62;
  TC_COLETA_VALOR_TOTAL              = $FC63;
  TC_COLETA_RG                       = $FC64;
  TC_DECIDE_RETENTATIVA              = $FC65;
  TC_CPF                             = $FC66;
  TC_COLETA_ENDERECO                 = $FC67;
  TC_COLETA_ANDAR                    = $FC68;
  TC_COLETA_CONJUNTO                 = $FC69;
  TC_COLETA_BLOCO                    = $FC6A;
  TC_COLETA_BAIRRO                   = $FC6B;
  TC_COLETA_AUT_OU_CARTAO            = $FC6C;
  TC_COLETA_DATA_EMISSAO_CARTAO      = $FC6D;
  TC_COLETA_PLANO_INFOCARDS          = $FC6E;
  TC_COLETA_NUM_CUPOM_FISCAL         = $FC6F;
  TC_COLETA_OPERADORA                = $FC70;
  TC_COLETA_DADOS_SAB                = $FC71;
  TC_COLETA_NUM_TELEFONE_COM_DV      = $FC72;
  TC_COLETA_DADOS_TRN_FORCADA_SAB    = $FC73;
  TC_DECIDE_SERVICO_TECNICO          = $FC74;
  TC_COLETA_NUMERO_OS                = $FC75;
  TC_COLETA_ID_TECNICO               = $FC76;
  TC_COLETA_COD_OCORRENCIA           = $FC77;
  TC_COLETA_EPS_CREDENCIADA          = $FC78;
  TC_DECIDE_VALOR_ENTRADA            = $FC79;
  TC_DECIDE_COLETA_VALOR_1aPARCELA   = $FC7A;
  TC_COLETA_VALOR_1aPARCELA          = $FC7B;
  TC_COLETA_DADOS_ADICIONAIS         = $FC7C;
  TC_COLETA_CANCELA_TRANSACAO        = $FC7D;
  TC_GO_ON_CHIP                      = $FC7E;
  TC_RETIRA_CARTAO                   = $FC7F;
  TC_COLETA_VALOR_TAXA_EMBARQUE      = $FC80;
  TC_EXIBE_MSG_SALDO                 = $FC81;
  TC_EXIBE_MSG_RETORNA_FLUXO         = $FC82;
  TC_EXIBE_MSG_AGUARDA_OPERADOR      = $FC83;
  TC_OBTEM_SERVICOS                  = $FC84;
  TC_CARTAO_DIGITADO                 = $FC85;
  TC_COLETA_COD_PRODUTO              = $FC86;
  TC_EXIBE_MENU                      = $FC87;
  TC_DECIDE_INSS                     = $FC88;
  TC_COLETA_CONTRATO                 = $FC89;
  TC_COLETA_DATA_CLIENTE_DESDE       = $FC8A;
  TC_DISP_VALOR                      = $FC8B;
  TC_COLETA_DATA_TRN_ORIG            = $FC8C;
  TC_COLETA_NSU_TRN_ORIG             = $FC8D;
  TC_EXIBE_DADOS_CANC                = $FC8E;
  TC_DECIDE_VIAS_REIMPRESSAO         = $FC8F;
  TC_COLETA_DDD_PP                   = $FC90;
  TC_COLETA_NUM_TEL_PP               = $FC91;
  TC_COLETA_NUM_TELEFONE_COM_DV_PP   = $FC92;
  TC_COLETA_REDIGITACAO_RECARGA_PP   = $FC93;
  TC_TRANSACAO_APROVADA_PARCIAL      = $FC94;
  TC_COLETA_VALOR_PARCELAS           = $FC95;
  TC_PRIMEIRA_PARCELA_30_60          = $FC96;
  TC_DECIDE_CDC_PARCELE_MAIS         = $FC97;
  TC_DECIDE_VENDAS_PAGAMENTOS        = $FC98;
  TC_DECIDE_AVISTA_CJUROS            = $FC99;
  TC_COLETA_TEF_EXT_NUMERO_CARTAO    = $FC9A;
  TC_TIPO_SERVICO_COMBUSTIVEL        = $FC9B;
  TC_MATRICULA                       = $FC9C;
  TC_QUANTIDADE_COMBUSTIVEL          = $FC9D;
  TC_HODOMETRO                       = $FC9E;
  TC_PLACA_VEICULO                   = $FC9F;
  TC_COLETA_CEL_COD_ATIVACAO         = $FCA0;
  TC_EXIBE_MENU_RESGATE_PREMIO       = $FCA1;
  TC_CONFIRMA_OPCAO_RESGATE_PREMIO   = $FCA2;
  TC_CLIENTE_CONFIRMA_RESGATE        = $FCA3;
  TC_NRO_RESGATE_PREMIO              = $FCA4;
  TC_COLETA_NRO_VOUCHER              = $FCA5;
  TC_DECIDE_DARF_GPS                 = $FCA6;
  TC_DECIDE_TIPO_DARF                = $FCA7;
  TC_COLETA_CODIGO_RECEITA           = $FCA8;
  TC_COLETA_NUMERO_REFERENCIA        = $FCA9;
  TC_COLETA_VALOR_JUROS              = $FCAA;
  TC_CPF_PORTADOR                    = $FCAB;
  TC_CNPJ                            = $FCAC;
  TC_COLETA_PERCENTUAL               = $FCAD;
  TC_COLETA_MMAAAA                   = $FCAE;
  TC_COLETA_NUMERO_IDENTIFICADOR     = $FCAF;
  TC_COLETA_VALOR_INSS               = $FCB0;
  TC_COLETA_RECEITA_BRUTA            = $FCB1;
  TC_CONTA_PERMIT_CONT_BRAD_TIT      = $FCB2;
  TC_COLETA_VALOR_ACRESCIMO          = $FCB3;
  TC_COLETA_VALOR_DEDUCAO            = $FCB4;
  TC_COLETA_REDIGITA_DDD_PP          = $FCB5;
  TC_COLETA_CARTAO_DIGITADO_PP       = $FCB6;
  TC_COLETA_DIG_FINAIS_CARTAO_PP     = $FCB7;
  TC_COLETA_TIPO_CONSULTA            = $FCB8;
  TC_CONFIRMA_CARTAO_DIGITADO_PP     = $FCB9;
  TC_VALIDA_SAQUE_AUTOMACAO          = $FCBA;
  TC_SAQUE_PP_EM_ANDAMENTO           = $FCBB;
  TC_COLETA_DDD_NUMTEL_PP            = $FCBC;
  TC_REDIGITA_DDD_NUMTEL_PP          = $FCBD;
  TC_COLETA_DADOS_ECF                = $FCBE;
  TC_COLETA_COD_EAN                  = $FCBF;
  TC_COLETA_HORA_TRN_ORIG            = $FCC0;
  TC_DECIDE_PGTO_CARNE               = $FCC1;
  TC_COLETA_MODALIDADE               = $FCC2;
  TC_COLETA_CODIGO_CODUTOR           = $FCC3;
  TC_COLETA_COD_COMBUSTIVEL          = $FCC4;
  TC_COLETA_VOUCHER_FROTA            = $FCC5;
  TC_COLETA_DADOS_CARTAO_PRESENTE    = $FCC6;
  TC_PRIMEIROS_DIGITOS               = $FCC7;
  TC_COLETA_CAMPO_AUT                = $FCC8;
  TC_COLETA_CAMPO_DOC                = $FCC9;
  TC_COLETA_LISTA_PRECOS             = $FCCA;
  TC_COLETA_LISTA_MERCADORIAS        = $FCCB;
  TC_HORIMETRO                       = $FCCC;
  TC_COLETA_CARTAO_MAGNETICO         = $FCCD;

  TC_COLETA_LISTA_PLANOS             = $FCCE;
  TC_DECIDE_EMPRESTIMO_SAQUE         = $FCCF;
  TC_COLETA_NUM_DOCUMENTO            = $FCD0;
  TC_COLETA_PROJETO                  = $FCD1;
  //TC_SENHA_NOVA                    = $FCD2;
  //TC_SENHA_NOVA_CONF               = $FCD3;
  TC_COLETA_SEGMENTO_SAV             = $FCD4;
  TC_COLETA_FORNECEDOR_SAV           = $FCD5;
  TC_COLETA_PRODUTO_SAV              = $FCD6;
  TC_COLETA_QUANTIDADE               = $FCD7;
  TC_COLETA_CLIENTE_PREFERENCIAL     = $FCD8;

  // --> Proximo Tipo Coleta AQUI (ACIMA) //
  TC_COLETA_CARTAO_EM_ANDAMENTO      = $FCFC;
  TC_COLETA_EM_ANDAMENTO             = $FCFD;
  TC_INFO_RET_FLUXO                  = $FCFE;
  TC_INFO_AGU_CONF_OP                = $FCFF;

  TC_PRIMEIRO_TIPO_COLETA            = TC_CARTAO;
  TC_MAX_TIPO_COLETA                 = TC_INFO_AGU_CONF_OP;


  {--------------------------------------------------------------------------------------------
  		Valores possiveis para o parametro da funcao ScopeValidaInterfacePP()
  --------------------------------------------------------------------------------------------}
  PP_NAO_UTILIZA                 = 0;
  PP_INTERFACE_LIB_VISA          = 1;
  PP_INTERFACE_LIB_COMPARTILHADA = 2;

  {--------------------------------------------------------------------------------------------
  		Valores possiveis para o parametro <Acao> da funcao ScopeFechaSessaoTEF()
  --------------------------------------------------------------------------------------------}
  ACAO_FECHA_DESFAZ_TEF   = 0;
  ACAO_FECHA_CONFIRMA_TEF = 1;


  {--------------------------------------------------------------------------------------------
  		Valores possiveis para o parametro <Acao> da funcao ScopeResumeParam()
  --------------------------------------------------------------------------------------------}
  COLETA_TECLADO          = $0004;
  COLETA_CARTAO_MAGNETICO = $0020;

  {--------------------------------------------------------------------------------------------
  		Valores possiveis para o parametro <Acao> da funcao ScopeResumeParam()
  --------------------------------------------------------------------------------------------}
  ACAO_RESUME_PROXIMO_ESTADO  = 0;
  ACAO_RESUME_ESTADO_ANTERIOR = 1;
  ACAO_RESUME_CANCELAR        = 2;
  ACAO_RESUME_APL_ERRO        = 3;

{--------------------------------------------------------------------------------------------
   Constantes de uso interno, n�o retornadas por Mask
--------------------------------------------------------------------------------------------}
const
  MASK0_CUPOM_LOJA     = $00000001;  { CupomLoja }
  MASK0_CUPOM_CLIENTE  = $00000002;  { CupomCliente }
  MASK0_CUPOM_REDUZIDO = $00000004;  { CupomReduzido }
  MASK0_CHEQUE_BANCO   = $00000008;
  MASK0_CHEQUE_AGENCIA = $00000010;
  MASK0_CHEQUE_NUMERO  = $00000020;
  MASK0_CHEQUE_VALOR   = $00000040;
  MASK0_CHEQUE_DATA    = $00000080;
  MASK0_CHEQUE_CODAUT  = $00000100;
  MASK0_CHEQUE_MUNICIP = $00000200;


//------------------------------------------------------------------------------
// DECLARACAO DAS ESTRUTURAS
//------------------------------------------------------------------------------
type
  //** Enumerador dos tipos das operadoras de celular */
  TEnumCelOperModelo = (
        REC_CEL_OPERADORAS_MODELO_1 = 1,
        REC_CEL_OPERADORAS_MODELO_2);


  { Enumerador dos tipos de estruturas retornadas
        para os valores de recarga }
  TEnumCelOperVals = (
        REC_CEL_VALORES_MODELO_1 = 1,
        REC_CEL_VALORES_MODELO_2,
        REC_CEL_VALORES_MODELO_3);


  //** dados utlizados na coleta de parametros */
  PParam_Coleta = ^TParam_Coleta;

  TParam_Coleta = packed record
    Bandeira: Word;
    FormatoDado: Word;
    HabTeclas: Word;
    MsgOp1: array [1..64]  of AnsiChar;
    MsgOp2: array [1..64]  of AnsiChar;
    MsgCl1: array [1..64]  of AnsiChar;
    MsgCl2: array [1..64]  of AnsiChar;
    WrkKey: array [1..17]  of AnsiChar;
    PosMasterKey: Word;
    PAN: array [1..20]  of AnsiChar;
    UsaCriptoPinpad: Byte;
    IdModoPagto: Byte;
    AceitaCartaoDigitado: Byte;
    Reservado: array [1..105] of AnsiChar;
  end;


  //** Estrutura devolvida pela funcao ScopeGetLastMsg() */
  PColeta_Msg = ^TColeta_Msg;

  TColeta_Msg = packed record
    Op1: array [1..64] of AnsiChar;
    Op2: array [1..64] of AnsiChar;
    Cl1: array [1..64] of AnsiChar;
    Cl2: array [1..64] of AnsiChar;
  end;


  //** Estrutura devolvida pela funcao ScopeGetCheque() */
  PParam_Cheq = ^TParam_Cheq;

  TParam_Cheq = packed record
    Banco:     array [1..04] of AnsiChar;
    Agencia:   array [1..05] of AnsiChar;
    NumCheque: array [1..13] of AnsiChar;
    Valor:     array [1..13] of AnsiChar;
    BomPara:   array [1..09] of AnsiChar;
    CodAut:    array [1..11] of AnsiChar;
    Municipio: array [1..41] of AnsiChar;
    Ordem:     SmallInt;
  end;


  //** Lista de Operadoras de Recarga de Celular retornadas pelo Servidor */
  PRec_Cel_Oper = ^TRec_Cel_Oper;

  TRec_Cel_Oper = packed record
    NumOperCel: SmallInt;
    OperCel:    array [1..2000] of AnsiChar;
  end;


  //** Lista de Operadoras de Recarga de Celular retornadas pelo Servidor */
  PRec_Cel_ID_Oper = ^TRec_Cel_ID_Oper;

  TRec_Cel_ID_Oper = packed record
    CodOperCel:  AnsiChar;
    NomeOperCel: array [1..21] of AnsiChar;
  end;


  //** Formato do valor para Recarga de Celular */
  PRec_Cel_Valor = ^TRec_Cel_Valor;

  TRec_Cel_Valor = packed record
    Valor: array [1..12] of AnsiChar;
    Bonus: array [1..12] of AnsiChar;
    Custo: array [1..12] of AnsiChar;
  end;

  TRec_Cel_Faixa_Valores = packed record
    ValorMin: array [1..12] of AnsiChar;
    ValorMax: array [1..12] of AnsiChar;
  end;


  //** Lista de Valores de Recarga de Celular retornadas pelo Servidor */
  PRec_Cel_Valores = ^TRec_Cel_Valores;

  TRec_Cel_Valores = packed record
    TipoValor:      AnsiChar;               { Tipo dos valores
                                              'V' - variavel(val min e val maximo)
                                              'F' - Fixo (apenas um valor fixo)
                                              'T' - Todos (tabela de valores) }
    ValorMinimo:    array [1..12] of AnsiChar;
    ValorMaximo:    array [1..12] of AnsiChar;
    Totvalor:       AnsiChar;
    TabValores:     array [1..10] of TRec_Cel_Valor;
    MsgPromocional: array [1..41] of AnsiChar;
    TotFaixaValores: AnsiChar;
    TabFaixaValores:array [1..10] of TRec_Cel_Faixa_Valores;
  end;

type
  EACBrTEFScopeAPI = class(Exception);

  TACBrTEFScopeOperacao = ( scoMenu, scoCredito, scoDebito, scoPagto, scoConsCDC, scoCheque, scoCanc,
                            scoReimpComp, scoResVenda, scoRecargaCel, scoPreAutCredito );

  TACBrTEFScopeGravarLog = procedure(const ALogLine: String; var Tratado: Boolean) of object ;

  TACBrTEFScopeTerminalMensagem = (tmOperador, tmCliente);

  TACBrTEFScopeExibeMensagem = procedure(
    const Mensagem: String;
    Terminal: TACBrTEFScopeTerminalMensagem;
    MilissegundosExibicao: Integer  // 0 - Para com OK; Positivo - aguarda Ok ou N milissegundos; Negativo - Apenas exibe a Msg (n�o aguarda)
    ) of object;

  TACBrTEFScopeExibeMenu = procedure(
    const Titulo: String;
    Opcoes: TStringList;
    var ItemSelecionado: Integer) of object ;  // -1 = Cancelado

  TACBrTEFScopePerguntarCampo = procedure(
    const MsgOperador: String; const MsgCliente: String;
    const TituloCampo: String;
    const AcoesPermitidas: Byte;
    var Resposta: String;
    var AcaoResposta: Byte) of object ;

  TACBrTEFScopeEstadoOperacao = ( scoestFluxoAPI,
                                  scoestAguardaUsuario,
                                  scoestPinPad,
                                  scoestPinPadLerCartao,
                                  scoestPinPadDigitacao,
                                  scoestRemoveCartao,
                                  scoestLeituraQRCode );

  TACBrTEFScopeTransacaoEmAndamento = procedure(
    EstadoOperacao: TACBrTEFScopeEstadoOperacao; out Cancelar: Boolean) of object;

  { TACBrTEFScopeAPI }

  TACBrTEFScopeAPI = Class
  private
    fCarregada: Boolean;
    fConectado: Boolean;
    fConfirmarTransacoesPendentes: Boolean;
    fControleConexao: Boolean;
    fCupomReduzido: Boolean;
    fDiretorioTrabalho: String;
    fEmpresa: String;
    fEmTransacao: Boolean;
    fEnderecoIP: String;
    fFilial: String;
    fInicializada: Boolean;
    fMsgPinPad: String;
    fDadosDaTransacao: TStringList;
    fOnExibeMensagem: TACBrTEFScopeExibeMensagem;
    fOnExibeMenu: TACBrTEFScopeExibeMenu;
    fOnGravarLog: TACBrTEFScopeGravarLog;
    fOnPerguntaCampo: TACBrTEFScopePerguntarCampo;
    fOnTransacaoEmAndamento: TACBrTEFScopeTransacaoEmAndamento;
    fPathLib: String;
    fPDV: String;
    fPermitirCancelarOperacaoPinPad: Boolean;
    fPermitirCartaoDigitado: Boolean;
    fPermitirSaque: Boolean;
    fPinPadSeguro: Boolean;
    fPortaPinPad: String;
    fPortaTCP: String;
    fSessaoAberta: Boolean;
    fVersaoAutomacao: String;

    // Funcoes originais do SCOPE
    xScopeOpen: function(Modo, Empresa, Filial, Pdv: PAnsiChar): LongInt;
      {$IfDef MSWINDOWS}stdcall{$Else}cdecl{$EndIf};
    xScopeClose: function(): LongInt; {$IfDef MSWINDOWS}stdcall{$Else}cdecl{$EndIf};
    xScopeVersao: function(_Versao: PAnsiChar; _TamBufVersao: LongInt): LongInt;
      {$IfDef MSWINDOWS}stdcall{$Else}cdecl{$EndIf};
    xScopeCompraCartaoCredito: function (Valor, TxServico: PAnsiChar): LongInt;
      {$IfDef MSWINDOWS}stdcall{$Else}cdecl{$EndIf};
    xScopeAbreSessaoTEF: function(): LongInt; {$IfDef MSWINDOWS}stdcall{$Else}cdecl{$EndIf};
    xScopeSetAplColeta: function(): LongInt; {$IfDef MSWINDOWS}stdcall{$Else}cdecl{$EndIf};
    xScopeStatus: function(): LongInt; {$IfDef MSWINDOWS}stdcall{$Else}cdecl{$EndIf};
    xScopeGetParam: function (_TipoParam: LongInt; _lpParam: PParam_Coleta): LongInt;
      {$IfDef MSWINDOWS}stdcall{$Else}cdecl{$EndIf};
    xScopeResumeParam: function(_CodTipoColeta: LongInt; _Dados: PAnsiChar;
      _DadosParam: Word; _Acao: LongInt): LongInt;
      {$IfDef MSWINDOWS}stdcall{$Else}cdecl{$EndIf};
    xScopeGetLastMsg: function(_ptParamColetaMsg: PColeta_Msg): LongInt;
      {$IfDef MSWINDOWS}stdcall{$Else}cdecl{$EndIf};
    xScopeGetCheque: function (_ptParamCheque: PParam_Cheq): LongInt;
      {$IfDef MSWINDOWS}stdcall{$Else}cdecl{$EndIf};
    xScopeGetCupomEx: function(_CabecLen: Word; _Cabec: PAnsiChar;
      _CupomClienteLen: Word; _CupomCliente: PAnsiChar; _CupomLojaLen: Word;
      _CupomLoja: PAnsiChar; _CupomReduzLen: Word; _CupomReduz: PAnsiChar;
      _NroLinhasReduz: PByte): LongInt; {$IfDef MSWINDOWS}stdcall{$Else}cdecl{$EndIf};
    xScopeFechaSessaoTEF: function(_Acao: Byte; _DesfezTEFAposQuedaEnergia: PByte): LongInt;
      {$IfDef MSWINDOWS}stdcall{$Else}cdecl{$EndIf};
    xScopeConsultaCDC: function(_Valor, _TxServico: PAnsiChar): LongInt;
      {$IfDef MSWINDOWS}stdcall{$Else}cdecl{$EndIf};
    xScopeCompraCartaoDebito: function(Valor: PAnsiChar): LongInt;
      {$IfDef MSWINDOWS}stdcall{$Else}cdecl{$EndIf};
    xScopeConsultaCheque: function(Valor: PAnsiChar): LongInt;
      {$IfDef MSWINDOWS}stdcall{$Else}cdecl{$EndIf};
    xScopeCancelamento: function(_Valor, _TxServico: PAnsiChar): LongInt;
      {$IfDef MSWINDOWS}stdcall{$Else}cdecl{$EndIf};
    xScopeReimpressaoComprovante: function(): LongInt;
      {$IfDef MSWINDOWS}stdcall{$Else}cdecl{$EndIf};
    xScopeResumoVendas: function(): LongInt;
      {$IfDef MSWINDOWS}stdcall{$Else}cdecl{$EndIf};
    xScopeObtemCampoExt: function(_Handle, _Masc, _Masc2: LongInt;
      _FieldSeparator: Byte; _Buffer: PAnsiChar): LongInt;
      {$IfDef MSWINDOWS}stdcall{$Else}cdecl{$EndIf};
    xScopeObtemCampoExt2: function(_Handle, _Masc, _Masc2, _Masc3: LongInt;
      _FieldSeparator: Byte; _Buffer: PAnsiChar): LongInt;
      {$IfDef MSWINDOWS}stdcall{$Else}cdecl{$EndIf};
    xScopeObtemCampoExt3: function(_Handle, _Masc, _Masc2, _Masc3, _Masc4: LongInt;
      _FieldSeparator: Byte; _Buffer: PAnsiChar): LongInt;
      {$IfDef MSWINDOWS}stdcall{$Else}cdecl{$EndIf};
    xScopeObtemHandle: function(_Desloc: LongInt): LongInt;
      {$IfDef MSWINDOWS}stdcall{$Else}cdecl{$EndIf};
    xScopePagamento: function(_Servico, _CodBandeira: Word): LongInt;
      {$IfDef MSWINDOWS}stdcall{$Else}cdecl{$EndIf};
    xScopeRecargaCelular: function(): LongInt;
      {$IfDef MSWINDOWS}stdcall{$Else}cdecl{$EndIf};
    xScopePreAutorizacaoCredito: function(_Valor, _TxServico: PAnsiChar): LongInt;
      {$IfDef MSWINDOWS}stdcall{$Else}cdecl{$EndIf};
    xScopeRecuperaOperadorasRecCel: function(_TipoTabela: Byte; _Buffer: PAnsiChar;
      _TamBuffer: Word): LongInt; {$IfDef MSWINDOWS}stdcall{$Else}cdecl{$EndIf};
    xScopeRecuperaValoresRecCel: function(_TipoTabela: Byte; _Buffer: PAnsiChar;
      _TamBuffer: Word): LongInt; {$IfDef MSWINDOWS}stdcall{$Else}cdecl{$EndIf};
    xScopeConfigura: function(_Id, _Param: LongInt): LongInt;
      {$IfDef MSWINDOWS}stdcall{$Else}cdecl{$EndIf};
    xScopeValidaInterfacePP: function(IntPP: Byte): LongInt;
      {$IfDef MSWINDOWS}stdcall{$Else}cdecl{$EndIf};
    //Busca informa��es de configura��es no servidor deles...
    xScopeConsultaPP: function(Configurado, UsoExclusivoScope, Porta: PByte): LongInt;
      {$IfDef MSWINDOWS}stdcall{$Else}cdecl{$EndIf};

    xScopePPOpenSecure: function(TipoCanal: word; Endereco: PAnsiChar): LongInt
      {$IfDef MSWINDOWS}stdcall{$Else}cdecl{$EndIf};
    xScopePPClose: function(IdleMsg: PAnsiChar): LongInt;
      {$IfDef MSWINDOWS}stdcall{$Else}cdecl{$EndIf};
    xScopePPGetCOMPort: function(szComEndereco: PAnsiChar): LongInt;
      {$IfDef MSWINDOWS}stdcall{$Else}cdecl{$EndIf};
//E
  //Implementar??
    //xScopePPGetInfoEx
    //ScopePPStartGetData
    //ScopePPGetData
    //ScopePPStartOptionMenu
    //ScopePPOptionMenu]
    //ScopePPGetOperationMode
    xScopeMenu: function(_UsoFuturo: LongInt): LongInt; {$IfDef MSWINDOWS}stdcall{$Else}cdecl{$EndIf};
    xScopePPDisplay: function(Msg: PAnsiChar): LongInt; {$IfDef MSWINDOWS}stdcall{$Else}cdecl{$EndIf};
    //ScopePPDisplayEx
  //Descontinuadas (p�g. 142)
    xScopePPOpen: function(Porta: Word): LongInt; {$IfDef MSWINDOWS}stdcall{$Else}cdecl{$EndIf};
    //xScopePPGetInfo
    //xScopePPStartGetPIN
  //.... Descontinuadas

    procedure SetPathLib(const AValue: String);
    procedure SetDiretorioTrabalho(AValue: String);
    procedure SetEmpresa(const AValue: String);
    procedure SetFilial(const AValue: String);
    procedure SetPDV(const AValue: String);
    procedure SetInicializada(AValue: Boolean);
    procedure SetControleConexao(AValue: Boolean);
    procedure SetEnderecoIP(AValue: String);
    procedure SetPortaTCP(AValue: String);

    procedure SetEmTransacao(AValue: Boolean);
    procedure ChamarEventoTransacaoEmAndamento(EstadoOperacao: TACBrTEFScopeEstadoOperacao;
      out Cancelar: Boolean);

  protected
    function GetLibFullPath: String;
    function GetScopeIniFullPath: String;

    procedure LoadLibFunctions;
    procedure UnLoadLibFunctions;
    procedure ClearMethodPointers;

    procedure DoException(const AErrorMsg: String );

    procedure TratarErroScope(AErrorCode: LongInt);

    procedure AbrirComunicacaoScope;
    procedure FecharComunicacaoScope;
    procedure VerificarSeEstaConectadoScope;
    procedure VerificarSeMantemConexaoScope;

    procedure VerificaSessaoTEFAnterior;

    procedure AbrirPinPad;
    procedure ConfigurarColeta;
    function ConfigurarScope(AId: LongInt; Ligado: Boolean): Boolean;
    procedure FecharPinPad;

    procedure VerificarDiretorioDeTrabalho;
    procedure VerificarEAjustarScopeINI;
    function ConfigurarPortaPinPad(const APortaPinPad: String): Word;
    procedure ObterDadosScopeINI(out AEmpresa: String; out AFilial: String;
      out AEnderecoIP: String; out APortaTCP: String);

    procedure ExibirMensagem(const AMsg: String;
      Terminal: TACBrTEFScopeTerminalMensagem = tmOperador; TempoEspera: Integer = -1);

    function ObterScopeStatus: Longint;
    function ObterDadosComprovantes: Longint;
    procedure ObterDadosCheque;
    procedure ObterDadosDaTransacao;
    procedure ExibirErroUltimaMsg;
    procedure LogColeta(AColeta: TParam_Coleta);

  public
    constructor Create;
    destructor Destroy; override;

    property PathLib: String read fPathLib write SetPathLib;
    property DiretorioTrabalho: String read fDiretorioTrabalho write SetDiretorioTrabalho;
    property ControleConexao: Boolean read fControleConexao write SetControleConexao default True;

    property Empresa: String read fEmpresa write SetEmpresa;
    property Filial: String read fFilial write SetFilial;
    property PDV: String read fPDV write SetPDV;
    property EnderecoIP: String  read fEnderecoIP write SetEnderecoIP;
    property PortaTCP: String read fPortaTCP write SetPortaTCP;

    property DadosDaTransacao: TStringList read fDadosDaTransacao;

    property PortaPinPad: String read fPortaPinPad write fPortaPinPad;
    property MsgPinPad: String read fMsgPinPad write fMsgPinPad;
    property VersaoAutomacao: String read fVersaoAutomacao write fVersaoAutomacao;
    property PinPadSeguro: Boolean read fPinPadSeguro write fPinPadSeguro default True;
    property CupomReduzido: Boolean read fCupomReduzido write fCupomReduzido default False;
    property PermitirCartaoDigitado: Boolean read fPermitirCartaoDigitado
      write fPermitirCartaoDigitado default False;
    property PermitirCancelarOperacaoPinPad: Boolean read fPermitirCancelarOperacaoPinPad
      write fPermitirCancelarOperacaoPinPad default True;
    property PermitirSaque: Boolean read fPermitirSaque write fPermitirSaque default True;
    property ConfirmarTransacoesPendentes: Boolean read fConfirmarTransacoesPendentes
      write fConfirmarTransacoesPendentes default True;

    property Carregada: Boolean read fCarregada;
    property Inicializada: Boolean read fInicializada write SetInicializada;
    property Conectado: Boolean read fConectado;
    property SessaoAberta: Boolean read fSessaoAberta;
    property EmTransacao: Boolean read fEmTransacao;

    property OnExibeMensagem: TACBrTEFScopeExibeMensagem read fOnExibeMensagem
      write fOnExibeMensagem;
    property OnExibeMenu: TACBrTEFScopeExibeMenu read fOnExibeMenu
      write fOnExibeMenu;
    property OnPerguntaCampo: TACBrTEFScopePerguntarCampo read fOnPerguntaCampo
      write fOnPerguntaCampo;
    property OnTransacaoEmAndamento: TACBrTEFScopeTransacaoEmAndamento read fOnTransacaoEmAndamento
      write fOnTransacaoEmAndamento;

    property OnGravarLog: TACBrTEFScopeGravarLog read fOnGravarLog write fOnGravarLog;

    procedure Inicializar;
    procedure DesInicializar;

    procedure AbrirSessaoTEF;
    procedure FecharSessaoTEF(Confirmar: Boolean; out TransacaoFoiDesfeita: Boolean);
    procedure IniciarTransacao(Operacao: TACBrTEFScopeOperacao;
      const Param1: String = ''; const Param2: String = ''; const Param3: String = '');
    procedure ExecutarTransacao;
    function EnviarParametroTransacao(Acao: LongInt; codTipoColeta: LongInt = -1;
      Dados: AnsiString = ''; dadosParam: Word = 0): LongInt;
    procedure AbortarTransacao;

    function ObterVersaoScope: String;
    function AcharPortaPinPad: String;
    procedure ExibirMensagemPinPad(const MsgPinPad: String);

    procedure GravarLog(const AString: AnsiString; Traduz: Boolean = False);
  end;

implementation

uses
  IniFiles, StrUtils, TypInfo,
  ACBrUtil.Strings, ACBrUtil.Math, ACBrUtil.FilesIO;

{ TACBrTEFScopeAPI }

constructor TACBrTEFScopeAPI.Create;
begin
  inherited;
  fCarregada := False;
  fInicializada := False;
  fConectado := False;
  fSessaoAberta := False;
  fControleConexao := True;
  fPathLib := '';
  fDiretorioTrabalho := '';
  fEnderecoIP := '';
  fPortaTCP := '';
  fMsgPinPad := '';
  fVersaoAutomacao := '';
  fPinPadSeguro := True;
  fPortaPinPad := '';
  fCupomReduzido := False;
  fPermitirCartaoDigitado := False;
  fPermitirCancelarOperacaoPinPad := True;
  fPermitirSaque := True;
  fConfirmarTransacoesPendentes := True;
  fOnGravarLog := Nil;
  fOnExibeMensagem := Nil;
  fOnExibeMenu := Nil;
  fOnPerguntaCampo := Nil;
  fOnTransacaoEmAndamento := Nil;
  fDadosDaTransacao := TStringList.Create;
end;

destructor TACBrTEFScopeAPI.Destroy;
begin
  fOnGravarLog := Nil;
  fOnExibeMensagem := Nil;
  DesInicializar;
  fDadosDaTransacao.Free;
  inherited Destroy;
end;

procedure TACBrTEFScopeAPI.Inicializar;
begin
  if fInicializada then
    Exit;

  GravarLog('TACBrTEFScopeAPI.Inicializar');

  if not Assigned(fOnTransacaoEmAndamento) then
    DoException(Format(ACBrStr(sErrEventoNaoAtribuido), ['OnTransacaoEmAndamento']));
  if not Assigned(fOnExibeMenu) then
    DoException(Format(ACBrStr(sErrEventoNaoAtribuido), ['OnExibeMenu']));
  if not Assigned(fOnPerguntaCampo) then
    DoException(Format(ACBrStr(sErrEventoNaoAtribuido), ['OnPerguntaCampo']));
  if not Assigned(fOnExibeMensagem) then
    DoException(Format(ACBrStr(sErrEventoNaoAtribuido), ['OnExibeMensagem']));

  VerificarDiretorioDeTrabalho;
  //E: Se o arquivo INI estiver configurado, a chamada abaixo talvez possa ser dispensada.
  //Ver tamb�m fun��o ScopeOpenVerify() como poss�vel adi��o para essa feature.
  VerificarEAjustarScopeINI;
  LoadLibFunctions;

  fInicializada := True;
  fConectado := False;
  fSessaoAberta := False;

  AbrirPinPad;

  if not ControleConexao then
    AbrirComunicacaoScope;
end;

procedure TACBrTEFScopeAPI.DesInicializar;
var
  b: Boolean;
begin
  if not fInicializada then
    Exit;

  GravarLog('TACBrTEFScopeAPI.DesInicializar');
  FecharSessaoTEF(True, b);
  FecharComunicacaoScope;
  FecharPinPad;

  UnLoadLibFunctions;
  fInicializada := False;
end;

procedure TACBrTEFScopeAPI.GravarLog(const AString: AnsiString; Traduz: Boolean);
Var
  Tratado: Boolean;
  AStringLog: AnsiString;
begin
  if not Assigned(fOnGravarLog) then
    Exit;

  if Traduz then
    AStringLog := TranslateUnprintable(AString)
  else
    AStringLog := AString;

  Tratado := False;
  fOnGravarLog(AStringLog, Tratado);
end;

procedure TACBrTEFScopeAPI.SetPathLib(const AValue: String);
begin
  if fPathLib = AValue then
    Exit;

  GravarLog('TACBrTEFScopeAPI.SetPathLib( '+AValue+' )');

  if fInicializada then
    DoException(ACBrStr(sErrLibJaInicializda));

  fPathLib := PathWithDelim(ExtractFilePath(AValue));
end;

procedure TACBrTEFScopeAPI.SetDiretorioTrabalho(AValue: String);
begin
  if fDiretorioTrabalho = AValue then
    Exit;

  GravarLog('TACBrTEFScopeAPI.SetDiretorioTrabalho( '+AValue+' )');

  if fInicializada then
    DoException(ACBrStr(sErrLibJaInicializda));

  fDiretorioTrabalho := AValue;
end;

procedure TACBrTEFScopeAPI.SetInicializada(AValue: Boolean);
begin
  if fInicializada = AValue then
    Exit;

  GravarLog('TACBrTEFScopeAPI.SetInicializada( '+BoolToStr(AValue, True)+' )');

  if AValue then
    Inicializar
  else
    DesInicializar;
end;

procedure TACBrTEFScopeAPI.SetEmpresa(const AValue: String);
begin
  if fEmpresa = AValue then
    Exit;

  if fInicializada then
    DoException(ACBrStr(sErrLibJaInicializda));

  if (AValue = '') then
    fEmpresa := AValue
  else
    fEmpresa := Format('%.4d',[StrToIntDef(AValue, 0)]);
end;

procedure TACBrTEFScopeAPI.SetFilial(const AValue: String);
begin
  if fFilial = AValue then
    Exit;

  if fInicializada then
    DoException(ACBrStr(sErrLibJaInicializda));

  if (AValue = '') then
    fFilial := AValue
  else
    fFilial := Format('%.4d',[StrToIntDef(AValue, 0)]);
end;

procedure TACBrTEFScopeAPI.SetPDV(const AValue: String);
begin
  if fPDV = AValue then
    Exit;

  if fInicializada then
    DoException(ACBrStr(sErrLibJaInicializda));

  if (AValue = '') then
    fPDV := AValue
  else
    fPDV := Format('%.3d',[StrToIntDef(AValue, 0)]);
end;


procedure TACBrTEFScopeAPI.SetControleConexao(AValue: Boolean);
begin
  if fControleConexao = AValue then
    Exit;

  GravarLog('TACBrTEFScopeAPI.SetControleConexao( '+BoolToStr(AValue, True)+' )');

  if fInicializada then
    DoException(ACBrStr(sErrLibJaInicializda));

  fControleConexao := AValue;
end;

procedure TACBrTEFScopeAPI.SetEnderecoIP(AValue: String);
begin
  if fEnderecoIP = AValue then
    Exit;

  if fInicializada then
    DoException(ACBrStr(sErrLibJaInicializda));

  fEnderecoIP := Trim(AValue);
end;


procedure TACBrTEFScopeAPI.SetPortaTCP(AValue: String);
begin
  if fPortaTCP = AValue then
    Exit;

  if fInicializada then
    DoException(ACBrStr(sErrLibJaInicializda));

  fPortaTCP := Trim(AValue);
end;

procedure TACBrTEFScopeAPI.SetEmTransacao(AValue: Boolean);
begin
  if (not fInicializada) or (AValue = fEmTransacao) then
    Exit;

  fEmTransacao := AValue;

  if not fEmTransacao then
    ExibirMensagem('');
end;

procedure TACBrTEFScopeAPI.ChamarEventoTransacaoEmAndamento(
  EstadoOperacao: TACBrTEFScopeEstadoOperacao; out Cancelar: Boolean);
begin
  Cancelar := False;
  if not Assigned(fOnTransacaoEmAndamento) then
    Exit;

  GravarLog('  OnTransacaoEmAndamento( '+GetEnumName(TypeInfo(TACBrTEFScopeEstadoOperacao),
            integer(EstadoOperacao))+' )');
  fOnTransacaoEmAndamento(EstadoOperacao, Cancelar);
  GravarLog('    Cancelar: '+BoolToStr(Cancelar, True) );
end;

function TACBrTEFScopeAPI.GetLibFullPath: String;
begin
  if (PathLib <> '') then
  begin
    GravarLog(ACBrStr('TACBrTEFScopeAPI.LibFullName: Usando "PathLib" informado pela aplica��o: ')+PathLib);
    Result := PathLib + CScopeLib
  end
  else
    Result := ApplicationPath + CScopeLib;
end;

function TACBrTEFScopeAPI.GetScopeIniFullPath: String;
var
  sLibName: String;
begin
  sLibName := GetLibFullPath;
  Result := ExtractFilePath(sLibName) + CScopeINI;
end;

procedure TACBrTEFScopeAPI.LoadLibFunctions;

  procedure ScopeFunctionDetect(LibName, FuncName: AnsiString; var LibPointer: Pointer;
    FuncIsRequired: Boolean = True) ;
  begin
    if not Assigned( LibPointer )  then
    begin
      GravarLog('   '+FuncName);
      if not FunctionDetect(LibName, FuncName, LibPointer) then
      begin
        LibPointer := NIL ;
        if FuncIsRequired then
          DoException(Format(ACBrStr('Erro ao carregar a fun��o: %s de: %s'),[FuncName, LibName]))
        else
          GravarLog(Format(ACBrStr('     Fun��o n�o requerida: %s n�o encontrada em: %s'),[FuncName, LibName]));
        end ;
    end ;
  end;

var
  sLibName: string;
begin
  if fCarregada then
    Exit;

  sLibName := GetLibFullPath;
  GravarLog('TACBrTEFScopeAPI.LoadDLLFunctions - '+sLibName);

  ScopeFunctionDetect(sLibName, 'ScopeOpen', @xScopeOpen);
  ScopeFunctionDetect(sLibName, 'ScopeClose', @xScopeClose);
  ScopeFunctionDetect(sLibName, 'ScopeVersao', @xScopeVersao);
  ScopeFunctionDetect(sLibName, 'ScopeCompraCartaoCredito', @xScopeCompraCartaoCredito);
  ScopeFunctionDetect(sLibName, 'ScopeAbreSessaoTEF', @xScopeAbreSessaoTEF);
  ScopeFunctionDetect(sLibName, 'ScopeSetAplColeta', @xScopeSetAplColeta);
  ScopeFunctionDetect(sLibName, 'ScopeStatus', @xScopeStatus);
  ScopeFunctionDetect(sLibName, 'ScopeGetParam', @xScopeGetParam);
  ScopeFunctionDetect(sLibName, 'ScopeResumeParam', @xScopeResumeParam);
  ScopeFunctionDetect(sLibName, 'ScopeGetLastMsg', @xScopeGetLastMsg);
  ScopeFunctionDetect(sLibName, 'ScopeGetCheque', @xScopeGetCheque);
  ScopeFunctionDetect(sLibName, 'ScopeGetCupomEx', @xScopeGetCupomEx);
  ScopeFunctionDetect(sLibName, 'ScopeFechaSessaoTEF', @xScopeFechaSessaoTEF);
  ScopeFunctionDetect(sLibName, 'ScopeConsultaCDC', @xScopeConsultaCDC);
  ScopeFunctionDetect(sLibName, 'ScopeCompraCartaoDebito', @xScopeCompraCartaoDebito);
  ScopeFunctionDetect(sLibName, 'ScopeConsultaCheque', @xScopeConsultaCheque);
  ScopeFunctionDetect(sLibName, 'ScopeCancelamento', @xScopeCancelamento);
  ScopeFunctionDetect(sLibName, 'ScopeReimpressaoComprovante', @xScopeReimpressaoComprovante);
  ScopeFunctionDetect(sLibName, 'ScopeResumoVendas', @xScopeResumoVendas);
  ScopeFunctionDetect(sLibName, 'ScopeObtemCampoExt', @xScopeObtemCampoExt);
  ScopeFunctionDetect(sLibName, 'ScopeObtemCampoExt2', @xScopeObtemCampoExt2);
  ScopeFunctionDetect(sLibName, 'ScopeObtemCampoExt3', @xScopeObtemCampoExt3);
  ScopeFunctionDetect(sLibName, 'ScopeObtemHandle', @xScopeObtemHandle);
  ScopeFunctionDetect(sLibName, 'ScopePagamento', @xScopePagamento);
  ScopeFunctionDetect(sLibName, 'ScopeRecargaCelular', @xScopeRecargaCelular);
  ScopeFunctionDetect(sLibName, 'ScopePreAutorizacaoCredito', @xScopePreAutorizacaoCredito);
  ScopeFunctionDetect(sLibName, 'ScopeRecuperaOperadorasRecCel', @xScopeRecuperaOperadorasRecCel);
  ScopeFunctionDetect(sLibName, 'ScopeRecuperaValoresRecCel', @xScopeRecuperaValoresRecCel);
  ScopeFunctionDetect(sLibName, 'ScopeConfigura', @xScopeConfigura);
  ScopeFunctionDetect(sLibName, 'ScopeValidaInterfacePP', @xScopeValidaInterfacePP);
  ScopeFunctionDetect(sLibName, 'ScopeConsultaPP', @xScopeConsultaPP);
  ScopeFunctionDetect(sLibName, 'ScopePPOpen', @xScopePPOpen);
  ScopeFunctionDetect(sLibName, 'ScopePPOpenSecure', @xScopePPOpenSecure);
  ScopeFunctionDetect(sLibName, 'ScopePPClose', @xScopePPClose);
  ScopeFunctionDetect(sLibName, 'ScopePPGetCOMPort', @xScopePPGetCOMPort);
  ScopeFunctionDetect(sLibName, 'ScopePPDisplay', @xScopePPDisplay);
  ScopeFunctionDetect(sLibName, 'ScopeMenu', @xScopeMenu);

  fCarregada := True;
end;

procedure TACBrTEFScopeAPI.UnLoadLibFunctions;
var
  sLibName: String;
begin
  if not fCarregada then
    Exit;

  GravarLog('TACBrTEFScopeAPI.UnLoadDLLFunctions');

  sLibName := GetLibFullPath;
  UnLoadLibrary( sLibName );
  fCarregada := False;
  ClearMethodPointers;
end;

procedure TACBrTEFScopeAPI.ClearMethodPointers;
begin
  xScopeOpen := Nil;
  xScopeClose := Nil;
  xScopeVersao := Nil;
  xScopeCompraCartaoCredito := Nil;
  xScopeAbreSessaoTEF := Nil;
  xScopeSetAplColeta := Nil;
  xScopeStatus := Nil;
  xScopeGetParam := Nil;
  xScopeResumeParam := Nil;
  xScopeGetLastMsg := Nil;
  xScopeGetCheque := Nil;
  xScopeGetCupomEx := Nil;
  xScopeFechaSessaoTEF := Nil;
  xScopeConsultaCDC := Nil;
  xScopeCompraCartaoDebito := Nil;
  xScopeConsultaCheque := Nil;
  xScopeCancelamento := Nil;
  xScopeReimpressaoComprovante := Nil;
  xScopeResumoVendas := Nil;
  xScopeObtemCampoExt := Nil;
  xScopeObtemCampoExt2 := Nil;
  xScopeObtemCampoExt3 := Nil;
  xScopeObtemHandle := Nil;
  xScopePagamento := Nil;
  xScopeRecargaCelular := Nil;
  xScopePreAutorizacaoCredito := Nil;
  xScopeRecuperaOperadorasRecCel := Nil;
  xScopeRecuperaValoresRecCel := Nil;
  xScopeConfigura := Nil;
  xScopeValidaInterfacePP := Nil;
  xScopeConsultaPP := Nil;
  xScopePPOpen := Nil;
  xScopePPOpenSecure := Nil;
  xScopePPClose := Nil;
  xScopePPGetCOMPort := Nil;
  xScopePPDisplay := Nil;
end;

procedure TACBrTEFScopeAPI.DoException(const AErrorMsg: String);
begin
  if (Trim(AErrorMsg) = '') then
    Exit;

  GravarLog('TACBrTEFScopeAPI: '+AErrorMsg);
  raise EACBrTEFScopeAPI.Create(AErrorMsg);
end;

procedure TACBrTEFScopeAPI.VerificarDiretorioDeTrabalho;
begin
  if (fDiretorioTrabalho = '') then
    fDiretorioTrabalho := ApplicationPath + 'TEF' + PathDelim + 'ScopeAPI';

  if not DirectoryExists(fDiretorioTrabalho) then
    ForceDirectories(fDiretorioTrabalho);

  if not DirectoryExists(fDiretorioTrabalho) then
    DoException(ACBrStr(Format(sErrDirTrabalhoInvalido, [fDiretorioTrabalho])));
end;

procedure TACBrTEFScopeAPI.VerificarEAjustarScopeINI;
var
  ini: TMemIniFile;
  sl: TStringList;
  i: Integer;
  sPathScopeIni, SecName, sEmpresa, sFilial, sName, sPort: String;
  ApagaSessoPrincipal, SemSessaoPrincipal: Boolean;

  procedure AjustarParamSeNaoExistir(const ASessao: String; const AChave: String; ValorPadrao: String);
  begin
    if not ini.ValueExists(ASessao, AChave) then
      ini.WriteString(ASessao, AChave, ValorPadrao);
  end;

  procedure AjusarSessaoLogAPI(const ASessao: String);
  begin
    AjustarParamSeNaoExistir(ASessao, 'TraceLevel', '8');
    AjustarParamSeNaoExistir(ASessao, 'LogFiles', '4');
    AjustarParamSeNaoExistir(ASessao, 'LogSize', '3072000');
    ini.WriteString(ASessao, 'LogPath', fDiretorioTrabalho + PathDelim + 'logs');
  end;

begin
  sPathScopeIni := GetScopeIniFullPath;
  ApagaSessoPrincipal := (fEmpresa <> '') and (fFilial <> '');
  SemSessaoPrincipal := True;
  ini := TMemIniFile.Create(sPathScopeIni);
  sl := TStringList.Create;
  try
    ini.ReadSections(sl);
    for i := 0 to sl.Count-1 do
    begin
      SecName := sl[i];
      if (Length(SecName) = 8) and StrIsNumber(SecName) then
      begin
        sEmpresa := copy(SecName,1,4);
        sFilial := copy(SecName,5,4);

        if ApagaSessoPrincipal and ((fEmpresa <> sEmpresa) or (fFilial <> sFilial)) then
          ini.EraseSection(SecName)
        else
        begin
          SemSessaoPrincipal := False;

          if (fEnderecoIP <> '') then
            ini.WriteString(SecName, 'Name', fEnderecoIP)
          else
            if not ini.ValueExists(SecName, 'Name') then
              DoException(ACBrStr(sErrEndServNaoEncontrado));

          if (fPortaTCP <> '') then
            ini.WriteString(SecName, 'Port', fPortaTCP)
          else
            AjustarParamSeNaoExistir(SecName, 'Port', '2046');
        end;

        AjustarParamSeNaoExistir(SecName, 'TimeOutAdm', '120');
        if (fVersaoAutomacao <> '') then
          sName := fVersaoAutomacao
        else
          sName := '01ACBR0000';

        AjustarParamSeNaoExistir(SecName, 'VersaoAutomacao', sName);
        AjustarParamSeNaoExistir(SecName, 'CupomReduzido', IfThen(fCupomReduzido, 's', 'n'));
        AjustarParamSeNaoExistir(SecName, 'NaoAbrirDigitado', IfThen(fPermitirCartaoDigitado, 'n', 's'));
        AjustarParamSeNaoExistir(SecName, 'WKPAN', IfThen(fPinPadSeguro, 's', 'n'));
        Break;
      end;
    end;

    if SemSessaoPrincipal then
    begin
      if (fEmpresa = '') then
        sEmpresa := '0001'
      else
        sEmpresa := fEmpresa;
      if (fFilial = '') then
        sFilial := '0001'
      else
        sFilial := fFilial;

      SecName := sEmpresa + sFilial;
      if (fEnderecoIP = '') then
        DoException(ACBrStr(sErrEndServNaoInformado))
      else
        ini.WriteString(SecName, 'Name', fEnderecoIP);

      if (fPortaTCP <> '') then
        sPort := fPortaTCP
      else
        sPort := '2046';

      ini.WriteString(SecName, 'Port', sPort);
      ini.WriteString(SecName, 'TimeOutAdm', '120');
      ini.WriteString(SecName, 'VersaoAutomacao', fVersaoAutomacao);
      ini.WriteString(SecName, 'CupomReduzido', IfThen(fCupomReduzido, 's', 'n'));
      ini.WriteString(SecName, 'NaoAbrirDigitado', IfThen(fPermitirCartaoDigitado, 'n', 's'));
      ini.WriteString(SecName, 'WKPAN', IfThen(fPinPadSeguro, 's', 'n'));
    end;

    AjustarParamSeNaoExistir('PINDPAD', 'TamMinDados', '4');

    SecName := 'SCOPEAPI';
    AjustarParamSeNaoExistir(SecName, 'TraceApi', 's');
    AjustarParamSeNaoExistir(SecName, 'TraceSrl', 's');
    AjustarParamSeNaoExistir(SecName, 'TracePin', 's');
    AjustarParamSeNaoExistir(SecName, 'RedecardBit47Tag6', '1');
    ini.WriteString(SecName, 'ArqControlPath', fDiretorioTrabalho + PathDelim + 'control');
    ini.WriteString(SecName, 'ArqTracePath', fDiretorioTrabalho + PathDelim + 'trace');

    AjusarSessaoLogAPI('SCOPELOGAPI');
    AjusarSessaoLogAPI('SCOPELOGPRF');

    ini.UpdateFile;
  finally
    sl.Free;
    ini.Free;
  end;
end;

procedure TACBrTEFScopeAPI.ObterDadosScopeINI(out AEmpresa: String; out
  AFilial: String; out AEnderecoIP: String; out APortaTCP: String);
var
  ini: TMemIniFile;
  sl: TStringList;
  SecName, sPathScopeIni: String;
  i: Integer;
begin
  AEmpresa := ''; AFilial := ''; AEnderecoIP := ''; APortaTCP := '';
  sPathScopeIni := GetScopeIniFullPath;
  if not FileExists(sPathScopeIni) then
    Exit;

  ini := TMemIniFile.Create(sPathScopeIni);
  sl := TStringList.Create;
  try
    ini.ReadSections(sl);
    for i := 0 to sl.Count-1 do
    begin
      SecName := sl[i];
      if (Length(SecName) = 8) and StrIsNumber(SecName) then
      begin
        AEmpresa := copy(SecName,1,4);
        AFilial := copy(SecName,5,4);
        AEnderecoIP := Trim(ini.ReadString(SecName, 'Name', ''));
        APortaTCP := Trim(ini.ReadString(SecName, 'Port', ''));
        Break;
      end;
    end;
  finally
    sl.Free;
    ini.Free;
  end;
end;

procedure TACBrTEFScopeAPI.ExibirMensagem(const AMsg: String;
  Terminal: TACBrTEFScopeTerminalMensagem; TempoEspera: Integer);
begin
  GravarLog('  OnExibeMensagem( '+AMsg+
            ', '+GetEnumName(TypeInfo(TACBrTEFScopeTerminalMensagem), integer(Terminal) )+
            ', '+IntToStr(TempoEspera)+' )', True);
  fOnExibeMensagem(AMsg, Terminal, TempoEspera);
end;

function TACBrTEFScopeAPI.ConfigurarPortaPinPad(const APortaPinPad: String
  ): Word;
var
  sPorta, sPathScopeIni: String;
  ini: TMemIniFile;
begin
  sPorta := APortaPinPad;
  Result := StrToIntDef(sPorta, 0);
  if (Result = 0) then
  begin
    sPorta := AcharPortaPinPad;
    Result := StrToIntDef(sPorta, 0);
  end;

  if (Result = 0) and (sPorta <> '') then
  begin
    sPathScopeIni := GetScopeIniFullPath;
    ini := TMemIniFile.Create(sPathScopeIni);
    try
      ini.WriteString('PPCOMP', 'SerialNumPorts', '1');
      ini.WriteString('PPCOMP', 'SerialPort0', sPorta);
      Result := 1;
    finally
      ini.Free;
    end;
  end;
end;

function TACBrTEFScopeAPI.ObterVersaoScope: String;
var
  ret: longint;
  pszData: PAnsiChar;
begin
  Result := '';
  pszData := AllocMem(13);
  try
    GravarLog('ScopeVersao()');
    ret := xScopeVersao(pszData, 13);
    GravarLog('  ret: '+IntToStr(ret));
    if (ret = RCS_SUCESSO) then
    begin
      Result := String(pszData);
      GravarLog('  Result: '+Result);
    end
    else
      TratarErroScope(ret);
  finally
    Freemem(pszData);
  end;
end;

function TACBrTEFScopeAPI.AcharPortaPinPad: String;
var
  ret: longint;
  pszData: PAnsiChar;
begin
  Result := '';
  pszData := AllocMem(48);
  try
    GravarLog('ScopePPGetCOMPort()');
    ret := xScopePPGetCOMPort(pszData);
    GravarLog('  ret: '+IntToStr(ret));
    if (ret = RCS_SUCESSO) then
    begin
      Result := String(pszData);
      GravarLog('  Result: '+Result);
    end;
  finally
    Freemem(pszData);
  end;
end;

procedure TACBrTEFScopeAPI.ExibirMensagemPinPad(const MsgPinPad: String);
var
  ret: LongInt;
begin
  GravarLog('xScopePPDisplay( '+MsgPinPad+' )');
  ret := xScopePPDisplay(PAnsiChar(MsgPinPad));
  GravarLog('  ret: '+IntToStr(ret));

  if ret <> PC_OK then
    TratarErroScope(ret);
end;

procedure TACBrTEFScopeAPI.TratarErroScope(AErrorCode: LongInt);
var
  MsgErro: String;
begin
//E
  //Adicionar erros como os do Pinpad (Ex.: PC_NAO_ABERTO_APP ver p�g 148)
  case AErrorCode of
    RCS_SUCESSO: MsgErro := '';
    RCS_TRN_EM_ANDAMENTO: MsgErro := ''; //'Transa��o em andamento';
    RCS_ERRO_PARM_1: MsgErro := 'Par�metro 1 inv�lido';
    RCS_ERRO_PARM_2: MsgErro := 'Par�metro 2 inv�lido';
    RCS_ERRO_PARM_3: MsgErro := 'Par�metro 3 inv�lido';
    RCS_ERRO_PARM_4: MsgErro := 'Par�metro 4 inv�lido';
    RCS_ERRO_ARQ_CICLO_TEF: MsgErro := 'Erro no arquivo de controle, finaliza��o multi-TEF';
    //D RCS_API_NAO_FEZ_TRN: MsgErro := 'Ainda n�o fez nenhuma transa��o ap�s a inicializa��o';
    RCS_API_NAO_INICIALIZADA: MsgErro := 'SCOPE API n�o foi inicializada';
    RCS_API_JA_INICIALIZADA: MsgErro := 'SCOPE API j� foi inicializada';
    RCS_SRV_NOT_CFG: MsgErro := 'Servidor n�o configurado no arquivo '+CScopeINi;
    RCS_ERRO_LOGON_PDV: MsgErro := 'Verificar o erro retornado no log do ScopeSrv';
    RCS_ERRO_CONFIG_PDV: MsgErro := 'Verifique a configura��o do perfil do PDV';
    //D RCS_THREAD_API_NOT_INIT: MsgErro := 'N�o foi poss�vel criar a �thread� na coleta de dados';
    RCS_ERRO_NUM_MAX_TEF_SESSAO: MsgErro := 'Estourou o n�mero m�ximo de TEF numa sess�o multi-TEF';
    RCS_NAO_HA_CAMPOS_SALVOS: MsgErro := 'N�o h� arquivo com dados da transa��o anterior salvo';
  else
    MsgErro := Format('Erro: %d', [AErrorCode]);
  end;

  if (MsgErro <> '') then
    DoException(ACBrStr(MsgErro));
end;

procedure TACBrTEFScopeAPI.AbrirComunicacaoScope;
var
  ret: LongInt;
  sEmpresa, sFilial, sPDV, sEnderecoIP, sPorta: String;
begin
  if fConectado then
    Exit;

  GravarLog('AbrirComunicacaoScope');

  ObterDadosScopeINI(sEmpresa, sFilial, sEnderecoIP, sPorta);
  ExibirMensagem( ACBrStr(Format(sMsgAbrindoConexao, [sEmpresa, sFilial]) ));
  if (fPDV = '') then
    sPDV := '001'
  else
    sPDV:= fPDV;

  GravarLog('ScopeOpen( 2, '+sEmpresa+', '+sFilial+', '+sPDV+' )');
  ret := xScopeOpen( PAnsiChar('2'),
                     PAnsiChar(AnsiString(sEmpresa)),
                     PAnsiChar(AnsiString(sFilial)),
                     PAnsiChar(AnsiString(sPDV)) );
  GravarLog('  ret: '+IntToStr(ret));
  if (ret <> RCS_SUCESSO) then
    TratarErroScope(ret);

  fConectado := True;
  //ExibirMensagem(Format(ACBrStr(sMsgConctadoAoServidor), [sEnderecoIP+':'+sPorta]));

  ConfigurarColeta;
  VerificaSessaoTEFAnterior;
end;

procedure TACBrTEFScopeAPI.FecharComunicacaoScope;
var
  ret:LongInt;
begin
  if not fConectado then
    Exit;

  GravarLog('ScopeClose()');
  ret := xScopeClose();
  GravarLog('  ret: '+IntToStr(ret));
  if (ret <> RCS_SUCESSO) and (ret <> RCS_API_NAO_INICIALIZADA) then
    TratarErroScope(ret);

  fConectado := False;
  //ExibirMensagem(ACBrStr(sMsgDesconectado));
end;

procedure TACBrTEFScopeAPI.VerificarSeEstaConectadoScope;
begin
  if fConectado then
    Exit;

  if not fControleConexao then
    DoException(ACBrStr(sErrNaoConectado));

  AbrirComunicacaoScope;
end;

procedure TACBrTEFScopeAPI.VerificarSeMantemConexaoScope;
begin
  if not fControleConexao then
    Exit;

  FecharComunicacaoScope;
end;

procedure TACBrTEFScopeAPI.AbrirSessaoTEF;
var
  ret: LongInt;
begin
  if fSessaoAberta then
    Exit;

  GravarLog('AbrirSessaoTEF');

  VerificarSeEstaConectadoScope;

  ExibirMensagem(ACBrStr(sMsgInicioSessaoTEF));
  GravarLog('ScopeAbreSessaoTEF()');
  ret := xScopeAbreSessaoTEF;
  GravarLog('  ret: '+IntToStr(ret));
  if (ret <> RCS_SUCESSO) then
    TratarErroScope(ret);

  ExibirMensagem('');
  fSessaoAberta := True;
end;

procedure TACBrTEFScopeAPI.FecharSessaoTEF(Confirmar: Boolean; out
  TransacaoFoiDesfeita: Boolean);
var
  Acao, DesfezTEF: Byte;
  ret: LongInt;
begin
  TransacaoFoiDesfeita := False;
  if not fSessaoAberta then
    Exit;

  GravarLog('FecharSessaoTEF( '+BoolToStr(Confirmar, True)+' )');
  if Confirmar then
    Acao := ACAO_FECHA_CONFIRMA_TEF
  else
    Acao := ACAO_FECHA_DESFAZ_TEF;

  DesfezTEF := 0;
  GravarLog('ScopeFechaSessaoTEF( '+IntToStr(Acao)+' )');
  ret := xScopeFechaSessaoTEF(Acao, @DesfezTEF);
  GravarLog('  ret: '+IntToStr(ret)+', DesfezTEF: '+IntToStr(DesfezTEF));
  if (ret <> RCS_SUCESSO) then
    TratarErroScope(ret);

  fSessaoAberta := False;

  VerificarSeMantemConexaoScope;
end;

procedure TACBrTEFScopeAPI.VerificaSessaoTEFAnterior;
var
  DesfezTEF: Boolean;
begin
  GravarLog('VerificaSessaoTEFAnterior');
  FecharSessaoTEF(fConfirmarTransacoesPendentes, DesfezTEF);
  if DesfezTEF then
  begin
    ExibirMensagem(sMsgTransacaoDesfeita, tmOperador, 0);
    ExibirMensagem('');
  end;
end;

procedure TACBrTEFScopeAPI.IniciarTransacao(Operacao: TACBrTEFScopeOperacao;
  const Param1: String; const Param2: String; const Param3: String);
var
  p1, p2, p3: PAnsiChar;
  ret: LongInt;
  b: Boolean;
begin
  GravarLog('IniciarTransacao( '+GetEnumName(TypeInfo(TACBrTEFScopeOperacao), integer(Operacao))+
            ', '+Param1+', '+Param2+', '+Param3+' )' );

  if fEmTransacao then
    DoException(ACBrStr(sErrTransacaoJaIniciada));

  if not fSessaoAberta then
    AbrirSessaoTEF;

  p1 := PAnsiChar(AnsiString(Param1));
  p2 := PAnsiChar(AnsiString(Param2));
  p3 := PAnsiChar(AnsiString(Param3));
  ret := 0;

  case Operacao of
    scoMenu:
      begin
        GravarLog('ScopeMenu( 0 )');
        ret := xScopeMenu(0);
      end;

    scoCredito:
      begin
        GravarLog('ScopeCompraCartaoCredito( '+Param1+', '+Param2+' )');
        ret := xScopeCompraCartaoCredito(p1, p2);
      end;

    scoDebito:
      begin
        GravarLog('ScopeCompraCartaoDebito( '+Param1+' )');
        ret := xScopeCompraCartaoDebito(p1);
      end;

    //TODO: escrever outras outras opera��es
  end;

  GravarLog('  ret: '+IntToStr(ret));
  if (ret <> RCS_SUCESSO) then
  begin
    FecharSessaoTEF(False, b);
    TratarErroScope(ret)
  end
  else
    SetEmTransacao(True);
end;

procedure TACBrTEFScopeAPI.ExecutarTransacao;
var
  ret, iStatus: LongInt;
  iBarra, Acao: Byte;
  rColeta: TParam_Coleta;
  TipoCaptura: Word;
  MsgOp, MsgCli, Titulo, Resposta: String;
const
  cBarras = '|/-\';

  function UsuarioCancelouATransacao(Fluxo: TACBrTEFScopeEstadoOperacao): Boolean;
  var
    Cancelar: Boolean;
  begin
    //Apenas Exibe uma mensagem na tela para n�o parecer que est� travado
    inc(iBarra);
    if (iBarra) > 4 then
      iBarra := 1;
    ExibirMensagem(Format(ACBrStr(sMsgTransacaoEmAndamento), [cBarras[iBarra]]));

    // Chama evento, permitindo ao usu�rio cancelar
    Cancelar := False;
    ChamarEventoTransacaoEmAndamento(Fluxo, Cancelar);
    Result := Cancelar;
  end;

begin
  GravarLog('ExecutarTransacao');

  if not fEmTransacao then
    DoException(ACBrStr(sErrTransacaoNaoIniciada));

  fDadosDaTransacao.Clear;
  iBarra := 0;

  while True do
  begin
    // Le o Status da Opera��o
    iStatus := ObterScopeStatus;
    Acao := ACAO_RESUME_PROXIMO_ESTADO;

    // Enquanto a transacao estiver em andamento, aguarda, mas verifica se o usu�rio Cancelou //
    if (iStatus = RCS_TRN_EM_ANDAMENTO) then
    begin
      if UsuarioCancelouATransacao(scoestFluxoAPI) then
        EnviarParametroTransacao(ACAO_RESUME_CANCELAR)
      else
        Sleep(CINTERVALO_COLETA);

      Continue;
    end;

    // Efetuando Leitura do Cart�o. Verifica se o operador cancelou a operacao via teclado //
    if (iStatus = TC_COLETA_CARTAO_EM_ANDAMENTO) then
    begin
      if UsuarioCancelouATransacao(scoestPinPadLerCartao) then
        Acao := ACAO_RESUME_CANCELAR;

      EnviarParametroTransacao(Acao);
      Continue;
    end;

    // Se estiver fora da faixa FC00 a FCFF, finaliza o processo //
    if ((iStatus < TC_PRIMEIRO_TIPO_COLETA) or (iStatus > TC_MAX_TIPO_COLETA)) then
      Break;

    // Coleta dados do Scope para esse passo //
    GravarLog('ScopeGetParam');
    FillChar(rColeta, SizeOf(TParam_Coleta), #0);
    ret := xScopeGetParam(iStatus, @rColeta);
    GravarLog('  ret: '+IntToStr(ret));
    if (ret <> RCS_SUCESSO) then
      TratarErroScope(ret);

    LogColeta(rColeta);
    // Exibe as mensagens do cliente e operador //
    MsgOp := Trim(String(rColeta.MsgOp1)) + sLineBreak + Trim(String(rColeta.MsgOp2));
    if (MsgOp <> '') then
      ExibirMensagem(MsgOp, tmOperador);

    MsgCli := Trim(String(rColeta.MsgCl1)) + sLineBreak + Trim(String(rColeta.MsgCl2));
    if (MsgCli <> '') then
      ExibirMensagem(MsgCli, tmCliente);

    Titulo := MsgOp;
    Resposta := '';
    TipoCaptura := COLETA_TECLADO;

    // Trata os estados //
    case iStatus of
      TC_CARTAO,                    // cartao //
      TC_COLETA_AUT_OU_CARTAO:;
        //TODO

      TC_IMPRIME_CHEQUE:            // imprime Cheque //
        ObterDadosCheque;

      TC_IMPRIME_CUPOM,             // imprime Cupom + Nota Promissoria + Cupom Promocional //
      TC_IMPRIME_CUPOM_PARCIAL,     // imprime Cupom Parcial //
      TC_IMPRIME_CONSULTA:
        ObterDadosComprovantes;

      TC_DISP_LISTA_MEDICAMENTO:;   // recupera lista de Medicamentos //
        //TODO

      TC_DISP_VALOR:;               // recupera valor do Vale Gas //
        //TODO

      TC_COLETA_REG_MEDICAMENTO:;   // se coletou lista de medicamentos, deve tambem atualizar o valor. //
        //TODO

      TC_INFO_RET_FLUXO,            // apenas mostra informacao e deve retornar ao scope //
      TC_COLETA_EM_ANDAMENTO:       // transacao em andamento //
        Acao := ACAO_RESUME_PROXIMO_ESTADO;

      TC_OBTEM_SERVICOS:;           // recupera os servicos configurados //
        //TODO:

      TC_COLETA_OPERADORA:;         // recupera a lista de operadoras da Recarga de Celular //
        //TODO:

      TC_COLETA_VALOR_RECARGA:;     // recupera a lista de valores da Recarga de Celular //
        //TODO:

      TC_SENHA:;                    // captura da senha do usuario //
        //TODO:

      TC_INFO_AGU_CONF_OP:;         // mostra informacao e aguarda confirmacao do usuario //
        //TODO:

      TC_COLETA_DADOS_ECF:;         // coleta dados do ECF e do cupom fiscal para a transacao de debito voucher com o TICKET CAR //
        //TODO:

      TC_COLETA_LISTA_MERCADORIAS:; // coleta Lista de Mercadorias para a transacao de debito voucher com o TICKET CAR //
        //TODO:

      TC_COLETA_LISTA_PRECOS:;      // coleta Lista para Atualizacao de Precos (TICKET CAR)
        //TODO:

    else                            // deve coletar algo... //
      fOnPerguntaCampo(MsgOp, MsgCli, Titulo, rColeta.HabTeclas, Resposta, Acao);

    end;

    ret := EnviarParametroTransacao(Acao, iStatus, Resposta, TipoCaptura);
    if (ret <> RCS_SUCESSO) then
    begin
      ExibirErroUltimaMsg;

      if (ret <> RCS_DADO_INVALIDO) then
        Break;
    end;
  end;

  if (iStatus = RCS_SUCESSO) then
  begin
    ExibirMensagem(sMsgTransacaoCompleta);
    ObterDadosDaTransacao;
  end
  else
    TratarErroScope(iStatus);
end;

function TACBrTEFScopeAPI.EnviarParametroTransacao(Acao: LongInt;
  codTipoColeta: LongInt; Dados: AnsiString; dadosParam: Word): LongInt;
begin
  if (codTipoColeta < 0) then
    codTipoColeta := ObterScopeStatus;

  GravarLog('ScopeResumeParam( '+IntToStr(codTipoColeta)+', "'+Dados+'", '+IntToStr(dadosParam)+', '+IntToStr(Acao)+' )');
  Result := xScopeResumeParam(codTipoColeta, PAnsiChar(Dados), dadosParam, Acao);
  GravarLog('  ret: '+IntToStr(Result));
end;

procedure TACBrTEFScopeAPI.AbortarTransacao;
begin
  EnviarParametroTransacao(ACAO_RESUME_CANCELAR);
  SetEmTransacao(False);
end;

function TACBrTEFScopeAPI.ObterScopeStatus: Longint;
begin
  GravarLog('ScopeStatus');
  Result := xScopeStatus;
  GravarLog('  ret: '+IntToStr(Result) + ' - $'+IntToHex(Result, 4));
end;

function TACBrTEFScopeAPI.ObterDadosComprovantes: Longint;
var
  pCabec, pCupomCliente, pCupomLoja, pCupomReduzido: PAnsiChar;
  NumeroLinhasReduzido: Byte;
  sCabec: String;
const
  CMASK0 = 'mask0-';
begin
  pCabec := AllocMem(1024);
  pCupomCliente := AllocMem(2048);
  pCupomLoja := AllocMem(2048);
  pCupomReduzido := AllocMem(2048);
  try
    GravarLog('ScopeGetCupomEx');
    Result := xScopeGetCupomEx( SizeOf(pCabec), pCabec,
                                SizeOf(pCupomCliente), pCupomCliente,
                                SizeOf(pCupomLoja), pCupomLoja,
                                SizeOf(pCupomReduzido), pCupomReduzido,
                                @NumeroLinhasReduzido);
    GravarLog('  ret: '+IntToStr(Result));
    if (Result <> RCS_SUCESSO) then
      TratarErroScope(Result);

    sCabec := String(pCabec);
    fDadosDaTransacao.Values[CMASK0 + IntToHex(MASK0_CUPOM_LOJA, 8)] := BinaryStringToString( sCabec + sLineBreak + String(pCupomLoja) );
    fDadosDaTransacao.Values[CMASK0 + IntToHex(MASK0_CUPOM_CLIENTE, 8)] := BinaryStringToString( sCabec + sLineBreak + String(pCupomCliente) );
    fDadosDaTransacao.Values[CMASK0 + IntToHex(MASK0_CUPOM_REDUZIDO, 8)] := BinaryStringToString( String(pCupomReduzido) );
  finally
    Freemem(pCabec);
    Freemem(pCupomCliente);
    Freemem(pCupomLoja);
    Freemem(pCupomReduzido);
  end;
end;

procedure TACBrTEFScopeAPI.ObterDadosCheque;
var
  PCheque: TParam_Cheq;
  ret: LongInt;
const
  CMASK0 = 'mask0-';
begin
  GravarLog('ScopeGetCheque');
  ret := xScopeGetCheque(@PCheque);
  GravarLog('  ret: '+IntToStr(ret));
  if (ret <> RCS_SUCESSO) then
    TratarErroScope(ret);

  fDadosDaTransacao.Values[CMASK0 + IntToHex(MASK0_CHEQUE_BANCO, 8)]   := String(PCheque.Banco);
  fDadosDaTransacao.Values[CMASK0 + IntToHex(MASK0_CHEQUE_AGENCIA, 8)] := String(PCheque.Agencia);
  fDadosDaTransacao.Values[CMASK0 + IntToHex(MASK0_CHEQUE_NUMERO, 8)]  := String(PCheque.NumCheque);
  fDadosDaTransacao.Values[CMASK0 + IntToHex(MASK0_CHEQUE_VALOR, 8)]   := String(PCheque.Valor);
  fDadosDaTransacao.Values[CMASK0 + IntToHex(MASK0_CHEQUE_DATA, 8)]    := String(PCheque.BomPara);
  fDadosDaTransacao.Values[CMASK0 + IntToHex(MASK0_CHEQUE_CODAUT, 8)]  := String(PCheque.CodAut);
  fDadosDaTransacao.Values[CMASK0 + IntToHex(MASK0_CHEQUE_MUNICIP, 8)] := String(PCheque.Municipio);
end;

procedure TACBrTEFScopeAPI.ObterDadosDaTransacao;
var
  pBuffer: PAnsiChar;
  h, i, ret, mask: LongInt;
  val, hmask: string;
begin
  fDadosDaTransacao.Clear;

  //* receber o identificador da transacao */
  GravarLog('ScopeObtemHandle');
  h := xScopeObtemHandle(0);
  GravarLog('  ret: '+IntToStr(h));

  if (h <= RCS_ERRO_GENERICO) then
    TratarErroScope(h);

  pBuffer := AllocMem(1024);
  try
    mask := 1;
    for i := 1 to 32 do
    begin
      FillChar(pBuffer , length(pBuffer), #0);
      hmask := '$'+IntToHex(mask, 8);
      GravarLog('ScopeObtemCampoExt3( '+IntToStr(h)+', '+hmask+', 0, 0, 0, : )');
      ret := xScopeObtemCampoExt3(h, mask, 0, 0, 0, Byte(':'), pBuffer);
      GravarLog('  ret: '+IntToStr(ret));
      val := String(pBuffer);
      fDadosDaTransacao.Add(Format('%s-%s=%s', ['mask1', hmask, val]));
      mask := mask shl 1;
    end;

    for i := 1 to 32 do
    begin
      FillChar(pBuffer , length(pBuffer), #0);
      hmask := '$'+IntToHex(mask, 8);
      GravarLog('ScopeObtemCampoExt3( '+IntToStr(h)+', 0, '+hmask+', 0, 0, : )');
      ret := xScopeObtemCampoExt3(h, 0, mask, 0, 0, Byte(':'), pBuffer);
      GravarLog('  ret: '+IntToStr(ret));
      val := String(pBuffer);
      fDadosDaTransacao.Add(Format('%s-%s=%s', ['mask2', hmask, val]));
      mask := mask shl 1;
    end;

    for i := 1 to 32 do
    begin
      FillChar(pBuffer , length(pBuffer), #0);
      hmask := '$'+IntToHex(mask, 8);
      GravarLog('ScopeObtemCampoExt3( '+IntToStr(h)+', 0, 0, '+hmask+', 0, : )');
      ret := xScopeObtemCampoExt3(h, 0, 0, mask, 0, Byte(':'), pBuffer);
      GravarLog('  ret: '+IntToStr(ret));
      val := String(pBuffer);
      fDadosDaTransacao.Add(Format('%s-%s=%s', ['mask3', hmask, val]));
      mask := mask shl 1;
    end;

    for i := 1 to 32 do
    begin
      FillChar(pBuffer , length(pBuffer), #0);
      hmask := '$'+IntToHex(mask, 8);
      GravarLog('ScopeObtemCampoExt3( '+IntToStr(h)+', 0, 0, 0, '+hmask+', : )');
      ret := xScopeObtemCampoExt3(h, 0, 0, 0, mask, Byte(':'), pBuffer);
      GravarLog('  ret: '+IntToStr(ret));
      val := String(pBuffer);
      fDadosDaTransacao.Add(Format('%s-%s=%s', ['mask4', hmask, val]));
      mask := mask shl 1;
    end;
  finally
    Freemem(pBuffer);
  end;
end;

procedure TACBrTEFScopeAPI.ExibirErroUltimaMsg;
var
  MsgColetada: TColeta_Msg;
  ret: LongInt;
  s, MsgOp, MsgCli: String;
begin
  // Coleta dados do Scope para esse passo //
  GravarLog('ScopeGetLastMsg');
  FillChar(MsgColetada, SizeOf(TColeta_Msg), #0);
  ret := xScopeGetLastMsg(@MsgColetada);
  GravarLog('  ret: '+IntToStr(ret));

  if (ret = RCS_SUCESSO) then
  begin
    s := 'Coleta_Msg.' + sLineBreak +
         '  Op1: '+String(MsgColetada.Op1) + sLineBreak +
         '  Op2: '+String(MsgColetada.Op2) + sLineBreak +
         '  Cl1: '+String(MsgColetada.Cl1) + sLineBreak +
         '  Cl2: '+String(MsgColetada.Cl2);
    GravarLog(s);

    // Exibe as mensagens do cliente e operador //
    MsgOp := Trim(String(MsgColetada.Op1)) + sLineBreak + Trim(String(MsgColetada.Op2));
    if (MsgOp <> '') then
      ExibirMensagem(MsgOp, tmOperador);

    MsgCli := Trim(String(MsgColetada.Cl1)) + sLineBreak + Trim(String(MsgColetada.Cl2));
    if (MsgCli <> '') then
      ExibirMensagem(MsgCli, tmCliente);
  end;

end;

procedure TACBrTEFScopeAPI.LogColeta(AColeta: TParam_Coleta);
var
  s: String;
begin
  s := 'Param_Coleta.' + sLineBreak +
       '  Bandeira: '+IntToStr(AColeta.Bandeira) + sLineBreak +
       '  FormatoDado: '+IntToStr(AColeta.FormatoDado) + sLineBreak +
       '  HabTeclas: '+IntToStr(AColeta.HabTeclas) + sLineBreak +
       '  MsgOp1: '+String(AColeta.MsgOp1) + sLineBreak +
       '  MsgOp2: '+String(AColeta.MsgOp2) + sLineBreak +
       '  MsgCl1: '+String(AColeta.MsgCl1) + sLineBreak +
       '  MsgCl2: '+String(AColeta.MsgCl2) + sLineBreak +
       '  WrkKey: '+String(AColeta.WrkKey) + sLineBreak +
       '  PosMasterKey: '+IntToStr(AColeta.PosMasterKey) + sLineBreak +
       '  PAN: '+String(AColeta.PAN) + sLineBreak +
       '  UsaCriptoPinpad: '+IntToStr(AColeta.UsaCriptoPinpad) + sLineBreak +
       '  IdModoPagto: '+IntToStr(AColeta.IdModoPagto) + sLineBreak +
       '  AceitaCartaoDigitado: '+IntToStr(AColeta.AceitaCartaoDigitado) + sLineBreak +
       '  Reservado: '+String(AColeta.Reservado);

  GravarLog(s);
end;

procedure TACBrTEFScopeAPI.AbrirPinPad;
var
  ret: LongInt;
  bConfig, bExclusivo, bPorta: Byte;
  Canal: Word;
  endereco: AnsiString;
begin
  FecharComunicacaoScope;
  GravarLog('AbrirPinPad');

  GravarLog('ScopeValidaInterfacePP( '+IntToStr(PP_INTERFACE_LIB_COMPARTILHADA)+' )');
  ret := xScopeValidaInterfacePP( PP_INTERFACE_LIB_COMPARTILHADA );
  GravarLog('  ret: '+IntToStr(ret));
  if ret <> PC_OK then
    TratarErroScope(ret);

  try
    VerificarSeEstaConectadoScope;

    GravarLog('ScopeConsultaPP()');
    ret := xScopeConsultaPP(@bConfig, @bExclusivo, @bPorta);
    GravarLog('  ret: '+IntToStr(ret)+
              ', Config:'+IntToStr(bConfig)+
              ', Exclusivo:'+IntToStr(bExclusivo)+
              ', Porta:'+IntToStr(bPorta) );
    if ret <> PC_OK then
      TratarErroScope(ret);

    if (bExclusivo = 0) then
    begin
      if (bPorta < 1) or (fPortaPinPad <> '') then
        bPorta := ConfigurarPortaPinPad(fPortaPinPad);

      if (bConfig = PPCONF_MODO_ABECS) then
        fPinPadSeguro := True;

      if fPinPadSeguro then
      begin
        if (bPorta = 0) then
          Canal := CANAL_COMM_NONE
        else
          Canal := CANAL_COMM_SERIAL;

        GravarLog('ScopePPOpenSecure( '+IntToStr(Canal)+', '+IntToStr(bPorta)+' )');
        endereco := IntToStr(bPorta);
        ret := xScopePPOpenSecure(Canal, PAnsiChar(endereco));
      end
      else
      begin
        GravarLog('ScopePPOpen( '+IntToStr(bPorta)+' )');
        ret := xScopePPOpen(bPorta);
      end;

      GravarLog('  ret: '+IntToStr(ret));
      if ret <> PC_OK then
        DoException(ACBrStr(Format('Erro %d ao abrir o PinPad', [ret])));
    end;
  finally
    VerificarSeMantemConexaoScope;
  end;
end;

procedure TACBrTEFScopeAPI.ConfigurarColeta;
var
  ret: LongInt;
begin
  GravarLog('ScopeSetAplColeta()');
  ret := xScopeSetAplColeta();
  GravarLog('  ret: '+IntToStr(ret));

  ConfigurarScope( CFG_CANCELAR_OPERACAO_PINPAD, fPermitirCancelarOperacaoPinPad);
  ConfigurarScope( CFG_NAO_ABRIR_DIGITADO_COM_PP, not fPermitirCartaoDigitado);
  ConfigurarScope( CFG_DEVOLVER_SENHA_CRIPTOGRAFADA, True);
  ConfigurarScope( CFG_IMPRESSORA_CARBONADA, False);
  ConfigurarScope( CFG_ARMAZENA_EM_QUEDA, False);
  ConfigurarScope( CFG_ATUALIZA_TRANSACAO_EM_QUEDA, fConfirmarTransacoesPendentes);
  ConfigurarScope( CFG_PERMITIR_SAQUE, fPermitirSaque);
end;

function TACBrTEFScopeAPI.ConfigurarScope(AId: LongInt; Ligado: Boolean
  ): Boolean;
var
  ret, AParam: LongInt;
begin
  if Ligado then
    AParam := OP_HABILITA
  else
    AParam := OP_DESABILITA;

  GravarLog('ScopeConfigura( '+IntToStr(AId)+', '+IntToStr(AParam) +' )');
  ret := xScopeConfigura(AId, AParam);
  GravarLog('  ret: '+IntToStr(ret));
  Result := (ret = RCS_SUCESSO);
end;

procedure TACBrTEFScopeAPI.FecharPinPad;
var
  msg: AnsiString;
  ret: LongInt;
begin
  GravarLog('FecharPinPad');

  if (Trim(fMsgPinPad) = '') then
    msg := 'ACBR - SCOPE'
  else
    msg := fMsgPinPad;

  GravarLog('ScopePPClose( '+msg+' )');
  ret := xScopePPClose(PAnsiChar(msg));
  GravarLog('  ret: '+IntToStr(ret));
end;

end.

