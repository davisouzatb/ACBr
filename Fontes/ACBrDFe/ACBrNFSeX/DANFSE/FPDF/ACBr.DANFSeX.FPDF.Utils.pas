{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para interação com equipa- }
{ mentos de Automação Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo: Italo Giurizzato Junior                         }
{                                                                              }
{  Você pode obter a última versão desse arquivo na pagina do  Projeto ACBr    }
{ Componentes localizado em      http://www.sourceforge.net/projects/acbr      }
{                                                                              }
{  Esta biblioteca é software livre; você pode redistribuí-la e/ou modificá-la }
{ sob os termos da Licença Pública Geral Menor do GNU conforme publicada pela  }
{ Free Software Foundation; tanto a versão 2.1 da Licença, ou (a seu critério) }
{ qualquer versão posterior.                                                   }
{                                                                              }
{  Esta biblioteca é distribuída na expectativa de que seja útil, porém, SEM   }
{ NENHUMA GARANTIA; nem mesmo a garantia implícita de COMERCIABILIDADE OU      }
{ ADEQUAÇÃO A UMA FINALIDADE ESPECÍFICA. Consulte a Licença Pública Geral Menor}
{ do GNU para mais detalhes. (Arquivo LICENÇA.TXT ou LICENSE.TXT)              }
{                                                                              }
{  Você deve ter recebido uma cópia da Licença Pública Geral Menor do GNU junto}
{ com esta biblioteca; se não, escreva para a Free Software Foundation, Inc.,  }
{ no endereço 59 Temple Street, Suite 330, Boston, MA 02111-1307 USA.          }
{ Você também pode obter uma copia da licença em:                              }
{ http://www.opensource.org/licenses/lgpl-license.php                          }
{                                                                              }
{ Daniel Simões de Almeida - daniel@projetoacbr.com.br - www.projetoacbr.com.br}
{       Rua Coronel Aureliano de Camargo, 963 - Tatuí - SP - 18270-170         }
{******************************************************************************}
unit ACBr.DANFSeX.FPDF.Utils;

interface

uses
  Classes,
  SysUtils,
  StrUtils,
  ACBrDFe.Conversao,
  ACBrNFSeX,
  ACBrNFSeXClass,
  ACBrNFSeXDANFSeClass,
  ACBrNFSeXConversao,

  StrUtilsEx;

type
  TLogoAlign = (laLeft, laCenter, laRight, laFull);

  TCanhotoAlign = (caNone, caTop, caLeft, caRight, caBottom);

  TNFSeUtilsFPDF = class
  private
    FDANFSEClassOwner: TACBrNFSeXDANFSeClass;
    FNFSe: TNFSe;
    FFormatSettings: TFormatSettings;
  public
    function NotaCancelada: boolean;
    function GetTextoAdicional: string;
    property DANFSEClassOwner: TACBrNFSeXDANFSeClass read FDANFSEClassOwner;
    property NFSe: TNFSe read FNFSe;
    constructor Create(ANFSe: TNFSe);
    destructor Destroy; override;

    property FormatSettings: TFormatSettings read FFormatSettings write FFormatSettings;
  end;

implementation

{ TNFSeUtilsFPDF }

constructor TNFSeUtilsFPDF.Create(ANFSe: TNFSe);
begin
  FNFSe := ANFSe;
  FDANFSEClassOwner := TACBrNFSeXDANFSeClass.Create(nil);
end;

destructor TNFSeUtilsFPDF.Destroy;
begin
  FDANFSEClassOwner.Free;
  inherited;
end;

function TNFSeUtilsFPDF.GetTextoAdicional: string;
begin
  Result := FastStringReplace(FNFSe.OutrasInformacoes, ';', sLineBreak, [rfReplaceAll]);
end;

function TNFSeUtilsFPDF.NotaCancelada: boolean;
begin
  Result := FNFSe.SituacaoNfse = ACBrNFSeXConversao.snCancelado;
end;

end.

