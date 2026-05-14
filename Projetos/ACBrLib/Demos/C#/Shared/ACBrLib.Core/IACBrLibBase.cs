using System;

namespace ACBrLib.Core
{

    /// <summary>
    /// Interface base para todas as bibliotecas ACBrLib.
    /// Define o contrato para opera��es comuns para classes de alto n�vel Da ACBrLib em C# 
    /// </summary>
    public interface IACBrLibBase
    {

        /// <summary>
        ///M�todo usado para inicializar o componente ACBr para uso da biblioteca.
        /// </summary>
        /// <param name="eArqConfig">Caminho do arquivo INI de configura��o. Se vazio, utiliza o padr�o da biblioteca.</param>
        /// <param name="eChaveCrypt">Chave de criptografia para o arquivo de configura��o. Se vazio, utiliza o padr�o da biblioteca.</param>
        void Inicializar(string eArqConfig = "", string eChaveCrypt = "");


        /// <summary>
        /// M�todo usado para remover o componente ACBr e suas classes da memoria.
        /// </summary>
        void Finalizar();

        /// <summary>
        /// M�todo usado para gravar a configura��o da biblioteca no arquivo INI informado.
        /// </summary>
        /// <param name="eArqConfig">Caminho do arquivo INI onde a configura��o ser� gravada. Se vazio, utiliza o padr�o da biblioteca.</param>
        void ConfigGravar(string eArqConfig = "");

        /// <summary>
        /// M�todo usado para ler a configura��o da biblioteca a partir do arquivo INI informado.
        /// </summary>
        /// <param name="eArqConfig">Caminho do arquivo INI de onde a configura��o ser� lida. Se vazio, utiliza o padr�o da biblioteca.</param>
        void ConfigLer(string eArqConfig = "");

        /// <summary>
        /// M�todo usado para ler um valor espec�fico da configura��o da biblioteca.
        /// </summary>
        /// <typeparam name="T">Tipo do valor a ser lido.</typeparam>
        /// <param name="eSessao">Sess�o da configura��o.</param>
        /// <param name="eChave">Chave da configura��o.</param>
        /// <returns>Valor da configura��o.</returns>
        T ConfigLerValor<T>(ACBrSessao eSessao, string eChave);

        /// <summary>
        /// M�todo usado para gravar um valor espec�fico na configura��o da biblioteca.
        /// </summary>
        /// <param name="eSessao">Sess�o da configura��o.</param>
        /// <param name="eChave">Chave da configura��o.</param>
        /// <param name="value">Valor a ser gravado.</param>
        void ConfigGravarValor(ACBrSessao eSessao, string eChave, object value);

        /// <summary>
        /// M�todo usado para importar a configura��o da biblioteca a partir de um arquivo INI.
        /// </summary>
        /// <param name="eArqConfig">Caminho do arquivo INI de onde a configura��o ser� importada.</param>
        void ImportarConfig(string eArqConfig);

        /// <summary>
        /// M�todo usado para exportar a configura��o da biblioteca para uma string.
        /// </summary>
        /// <returns>Configura��o da biblioteca em formato de string.</returns>
        string ExportarConfig();

        /// <summary>
        /// Retorna informa��es sobre a vers�o do OpenSSL utilizada pela biblioteca
        /// </summary>
        /// <returns></returns>
        string OpenSSLInfo();
    }
}