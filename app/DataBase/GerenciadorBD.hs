module DataBase.GerenciadorBD (module DataBase.GerenciadorBD) where

{- ==== META REQUISITOS ==== -}
import Data.Aeson
import qualified Data.ByteString.Lazy as B
import qualified Data.ByteString.Lazy.Char8 as BC
{- ==== IMPORTAÇÃO DO MODELO DOS OBJETOS DO SISTEMA ==== -}

import qualified Data.Maybe
import GHC.Generics
import Models.Cliente
import Models.Compra
import Models.Filme
import Models.Funcionario
import Models.Gerente
import Models.Jogo
import Models.Produto
import Models.Serie
import System.Directory
import System.IO
import System.IO.Unsafe

{- ==== CRIANDO INSTÂNCIAS DOS ARQUIVOS JSON PARA OS OBJETOS DEFINIDOS EM MODEL ==== -}
instance FromJSON Filme

instance ToJSON Filme

instance FromJSON Jogo

instance ToJSON Jogo

instance FromJSON Serie

instance ToJSON Serie

instance FromJSON Funcionario

instance ToJSON Funcionario

instance FromJSON Cliente

instance ToJSON Cliente

instance FromJSON Produto

instance ToJSON Produto

instance FromJSON Compra

instance ToJSON Compra

instance FromJSON Gerente

instance ToJSON Gerente

{- ==== MÉTODOS PARA BANCO  DE FILMES ==== -}
-- Pega todos os filmes --
getFilmeJSON :: FilePath -> IO [Filme]
getFilmeJSON path = do
  contents <- B.readFile path
  case eitherDecode' contents of
    Left err -> error err
    Right filmes -> return filmes

-- Salva um novo filme no arquivos de filmes --
saveFilmeJSON :: String -> String -> String -> String -> Float -> IO ()
saveFilmeJSON identificador nome descricao categoria preco = do
  let p = Filme identificador nome descricao categoria 0 preco
  filmeList <- getFilmeJSON "app/DataBase/Filme.json" 
  let newFilmeList = filmeList ++ [p]

  saveAlteracoesFilme newFilmeList

-- Pega um filme por id
getFilmeByID :: String -> [Filme] -> Filme
getFilmeByID _ [] = Filme "-1" "" "" "" 0 0.0
getFilmeByID identifierS (x : xs)
  | Models.Filme.identificador x == identifierS = x
  | otherwise = getFilmeByID identifierS xs

-- Pega um filme por nome
getFilmeByNome :: String -> [Filme] -> Filme
getFilmeByNome _ [] = Filme "-1" "" "" "" 0 0.0
getFilmeByNome nome (x : xs)
  | Models.Filme.nome x == nome = x
  | otherwise = getFilmeByNome nome xs

-- Remove um filme por id
removeFilmeByID :: String -> [Filme] -> [Filme]
removeFilmeByID _ [] = []
removeFilmeByID identifierS (x : xs)
  | Models.Filme.identificador x == identifierS = xs
  | otherwise = x : (removeFilmeByID identifierS xs)

-- Edita a quantidade de alugueis de filmes
editFilmeQtdJSON :: String -> Int -> IO ()
editFilmeQtdJSON identifier qtd = do
  filmeList <- getFilmeJSON "app/DataBase/Filme.json"
  let f = getFilmeByID identifier filmeList
  let p = Filme identifier (Models.Filme.nome f) (Models.Filme.descricao f) (Models.Filme.categoria f) qtd (Models.Filme.precoPorDia f)
  let newFilmeList = removeFilmeByID identifier filmeList ++ [p]

  saveAlteracoesFilme newFilmeList

-- Salve as uma lista de filmes alterados
saveAlteracoesFilme :: [Filme] -> IO ()
saveAlteracoesFilme filmeList = do
  B.writeFile "../Temp.json" $ encode filmeList
  removeFile "app/DataBase/Filme.json"
  renameFile "../Temp.json" "app/DataBase/Filme.json"

{- ==== MÉTODOS PARA BANCO  DE JOGOS ==== -}
-- Pega todos os Jogos --
getJogoJSON :: String -> [Jogo]
getJogoJSON path = do
  let file = unsafePerformIO (B.readFile path)
  let decodedFile = decode file :: Maybe [Jogo]
  Data.Maybe.fromMaybe [] decodedFile

-- Salva um novo Jogo no arquivos de Jogos --
saveJogoJSON :: String -> String -> String -> String -> Float -> IO ()
saveJogoJSON identificador nome descricao categoria preco = do
  let p = Jogo identificador nome descricao categoria 0 preco
  let newJogoList = getJogoJSON "app/DataBase/Jogo.json" ++ [p]

  saveAlteracoesJogo newJogoList

-- Pega um jogo por id
getJogoByID :: String -> [Jogo] -> Jogo
getJogoByID _ [] = Jogo "-1" "" "" "" 0 0.0
getJogoByID identifierS (x : xs)
  | Models.Jogo.identificador x == identifierS = x
  | otherwise = getJogoByID identifierS xs

-- Pega um jogo por nome
getJogoByNome :: String -> [Jogo] -> Jogo
getJogoByNome _ [] = Jogo "-1" "" "" "" 0 0.0
getJogoByNome nome (x : xs)
  | Models.Jogo.nome x == nome = x
  | otherwise = getJogoByNome nome xs

-- Remove um jogo por id
removeJogoByID :: String -> [Jogo] -> [Jogo]
removeJogoByID _ [] = []
removeJogoByID identifierS (x : xs)
  | Models.Jogo.identificador x == identifierS = xs
  | otherwise = x : (removeJogoByID identifierS xs)

-- Edita a quantidade de alugueis de um jogo
editJogoQtdJSON :: String -> Int -> IO ()
editJogoQtdJSON identifier qtd = do
  let jogoList = getJogoJSON "app/DataBase/Jogo.json"
  let f = getJogoByID identifier jogoList
  let p = Jogo identifier (Models.Jogo.nome f) (Models.Jogo.descricao f) (Models.Jogo.categoria f) qtd (Models.Jogo.precoPorDia f)
  let newJogoList = removeJogoByID identifier jogoList ++ [p]

  saveAlteracoesJogo newJogoList

-- Salva uma lista de jogos alterados
saveAlteracoesJogo :: [Jogo] -> IO ()
saveAlteracoesJogo jogoList = do
  B.writeFile "../Temp.json" $ encode jogoList
  removeFile "app/DataBase/Jogo.json"
  renameFile "../Temp.json" "app/DataBase/Jogo.json"

{- ==== MÉTODOS PARA BANCO  DE SERIES ==== -}
-- Pega todos os Series --
getSerieJSON :: String -> [Serie]
getSerieJSON path = do
  let file = unsafePerformIO (B.readFile path)
  let decodedFile = decode file :: Maybe [Serie]
  Data.Maybe.fromMaybe [] decodedFile

-- Salva um nova série no arquivos de Series --
saveSerieJSON :: String -> String -> String -> String -> Float -> IO ()
saveSerieJSON identificador nome descricao categoria preco = do
  let p = Serie identificador nome descricao categoria 0 preco
  let newSerieList = getSerieJSON "app/DataBase/Serie.json" ++ [p]

  saveAlteracoesSerie newSerieList

-- Pega um série por id
getSerieByID :: String -> [Serie] -> Serie
getSerieByID _ [] = Serie "-1" "" "" "" 0 0.0
getSerieByID identifierS (x : xs)
  | Models.Serie.identificador x == identifierS = x
  | otherwise = getSerieByID identifierS xs

-- Pega um série por nome
getSerieByNome :: String -> [Serie] -> Serie
getSerieByNome _ [] = Serie "-1" "" "" "" 0 0.0
getSerieByNome nome (x : xs)
  | Models.Serie.nome x == nome = x
  | otherwise = getSerieByNome nome xs

-- Remove um série por id
removeSerieByID :: String -> [Serie] -> [Serie]
removeSerieByID _ [] = []
removeSerieByID identifierS (x : xs)
  | Models.Serie.identificador x == identifierS = xs
  | otherwise = x : (removeSerieByID identifierS xs)

-- Edita a quantidade alugueis de uma série
editSerieQtdJSON :: String -> Int -> IO ()
editSerieQtdJSON identifier qtd = do
  let serieList = getSerieJSON "app/DataBase/Serie.json"
  let f = getSerieByID identifier serieList
  let p = Serie identifier (Models.Serie.nome f) (Models.Serie.descricao f) (Models.Serie.categoria f) qtd (Models.Serie.precoPorDia f)
  let newSerieList = removeSerieByID identifier serieList ++ [p]

  saveAlteracoesSerie newSerieList

-- Salva uma lista de séries alteradas
saveAlteracoesSerie :: [Serie] -> IO ()
saveAlteracoesSerie serieList = do
  B.writeFile "../Temp.json" $ encode serieList
  removeFile "app/DataBase/Serie.json"
  renameFile "../Temp.json" "app/DataBase/Serie.json"

{- ==== MÉTODOS PARA BANCO  DE CLIENTES ==== -}
-- Pega todos os Clientes --
getClienteJSON :: FilePath -> IO [Cliente]
getClienteJSON path = do
  contents <- B.readFile path
  case eitherDecode' contents of
    Left err -> error err
    Right clientes -> return clientes

saveClienteJSON :: String -> String -> IO ()
saveClienteJSON identificador nome = do
  let produtosList = [] :: [Produto]
  let compraList = [] :: [Compra]

  let p = Cliente identificador nome produtosList compraList

  existingClientes <- getClienteJSON "app/DataBase/Cliente.json"
  let newClienteList = existingClientes ++ [p]

  saveAlteracoesCliente newClienteList

-- Pega um cliente por id
getClienteByID :: String -> [Cliente] -> Cliente
getClienteByID _ [] = do
  let produtosList = [] :: [Produto]
  let compraList = [] :: [Compra]

  Cliente "-1" "" produtosList compraList
getClienteByID identifierS (x : xs)
  | Models.Cliente.identificador x == identifierS = x
  | otherwise = getClienteByID identifierS xs

-- Remove um cliente por id
removeClienteByID :: String -> [Cliente] -> [Cliente]
removeClienteByID _ [] = []
removeClienteByID identifierS (x : xs)
  | Models.Cliente.identificador x == identifierS = xs
  | otherwise = x : (removeClienteByID identifierS xs)

-- Eita o carrinho de um cliente adicionando um novo produto
editClienteCarrinhoJSON :: String -> Produto -> IO ()
editClienteCarrinhoJSON identifier produto = do
  existingClientes <- getClienteJSON "app/DataBase/Cliente.json"

  let f = getClienteByID identifier existingClientes
  let new_carrinho = Models.Cliente.carrinho f ++ [produto]
  let p = Cliente identifier (Models.Cliente.nome f) new_carrinho (Models.Cliente.historico f)
  let newClienteList = removeClienteByID identifier existingClientes ++ [p]

  saveAlteracoesCliente newClienteList

-- Remove um produto de uma lista de produtos
removeProduto :: String -> [Produto] -> [Produto]
removeProduto _ [] = []
removeProduto identifierS (x : xs)
  | Models.Produto.idProduto x == identifierS = xs
  | otherwise = x : (removeProduto identifierS xs)

-- Remove um produto do carrinho de um cliente
removeClienteProdutoJSON :: String -> String -> IO ()
removeClienteProdutoJSON identifier idProduto = do
  existingClientes <- getClienteJSON "app/DataBase/Cliente.json"
  let f = getClienteByID identifier existingClientes
  let new_carrinho = removeProduto idProduto (Models.Cliente.carrinho f)
  let p = Cliente identifier (Models.Cliente.nome f) new_carrinho (Models.Cliente.historico f)
  let newClienteList = removeClienteByID identifier existingClientes ++ [p]

  saveAlteracoesCliente newClienteList

-- Edita o histórico de um cliente adicionando uma compra
editClienteHistoricoJSON :: String -> Compra -> IO ()
editClienteHistoricoJSON identifier compra = do
  existingClientes <- getClienteJSON "app/DataBase/Cliente.json"
  let f = getClienteByID identifier existingClientes
  let new_historico = Models.Cliente.historico f ++ [compra]
  let p = Cliente identifier (Models.Cliente.nome f) (Models.Cliente.carrinho f) new_historico

  let newClienteList = removeClienteByID identifier existingClientes ++ [p]

  saveAlteracoesCliente newClienteList

-- Pega os produtos do carrinho
getCarrinhoProdutos :: String -> IO [Produto]
getCarrinhoProdutos idCliente = do
  existingClientes <- getClienteJSON "app/DataBase/Cliente.json"
  let cliente = getClienteByID idCliente existingClientes

  return $ Models.Cliente.carrinho cliente

-- Retorna uma string com os produtos
produtoToString :: [Produto] -> IO String
produtoToString produtos = helper produtos 1
  where
    helper [] _ = return ""
    helper (x : xs) i = do
      filmeList <- getFilmeJSON "app/DataBase/Filme.json"
      let serieList = getSerieJSON "app/DataBase/Serie.json"
      let jogoList = getJogoJSON "app/DataBase/Jogo.json"
      let f = getFilmeByID (Models.Produto.idProduto x) filmeList
      let s = getSerieByID (Models.Produto.idProduto x) serieList
      let j = getJogoByID (Models.Produto.idProduto x) jogoList
      let saida = show i ++ " - "
      if ((Models.Filme.identificador f) == "-1" && (Models.Serie.identificador s) == "-1")
        then do
          let info =
                "\nNome: "
                  ++ (Models.Jogo.nome j)
                  ++ "\n"
                  ++ "Descrição: "
                  ++ (Models.Jogo.descricao j)
                  ++ "\n"
                  ++ "Preço por dia: "
                  ++ show (Models.Jogo.precoPorDia j)
                  ++ "\n"
          (saida ++) <$> (info ++) <$> helper xs (i + 1)
        else
          if ((Models.Filme.identificador f) == "-1" && (Models.Jogo.identificador j) == "-1")
            then do
              let info =
                    "\nNome: "
                      ++ (Models.Serie.nome s)
                      ++ "\n"
                      ++ "Descrição: "
                      ++ (Models.Serie.descricao s)
                      ++ "\n"
                      ++ "Preço por dia: "
                      ++ show (Models.Serie.precoPorDia s)
                      ++ "\n"
              (saida ++) <$> (info ++) <$> helper xs (i + 1)
            else do
              let info =
                    "\nNome: "
                      ++ (Models.Filme.nome f)
                      ++ "\n"
                      ++ "Descrição: "
                      ++ (Models.Filme.descricao f)
                      ++ "\n"
                      ++ "Preço por dia: "
                      ++ show (Models.Filme.precoPorDia f)
                      ++ "\n"
              (saida ++) <$> (info ++) <$> helper xs (i + 1)


-- Pega carrinho
getCarrinho :: String -> IO String
getCarrinho idCliente = do
  produtos <- getCarrinhoProdutos idCliente
  produtoStr <- produtoToString produtos
  return produtoStr

-- Salva uma lista de clientes alterados
saveAlteracoesCliente :: [Cliente] -> IO ()
saveAlteracoesCliente clienteList = do
  B.writeFile "../Temp.json" $ encode clienteList
  removeFile "app/DataBase/Cliente.json"
  renameFile "../Temp.json" "app/DataBase/Cliente.json"

{- ==== MÉTODOS PARA BANCO  DE GERENTE ==== -}
-- Pega todos os Gerentes --
getGerenteJSON :: String -> [Gerente]
getGerenteJSON path = do
  let file = unsafePerformIO (B.readFile path)
  let decodedFile = decode file :: Maybe [Gerente]
  Data.Maybe.fromMaybe [] decodedFile

-- Salva um novo Gerente no arquivos de Gerentes --
saveGerenteJSON :: String -> String -> IO ()
saveGerenteJSON identificador nome = do
  let p = Gerente identificador nome
  let gerenteList = getGerenteJSON "app/DataBase/Gerente.json" ++ [p]

  B.writeFile "../Temp.json" $ encode gerenteList
  removeFile "app/DataBase/Gerente.json"
  renameFile "../Temp.json" "app/DataBase/Gerente.json"

-- Pega um gerente por Id
getGerenteByID :: String -> [Gerente] -> Gerente
getGerenteByID _ [] = Gerente "-1" ""
getGerenteByID identifierS (x : xs)
  | Models.Gerente.identificador x == identifierS = x
  | otherwise = getGerenteByID identifierS xs

{- ==== MÉTODOS PARA BANCO  DE FUNCIONÁRIO ==== -}
-- Pega todos os Funcionarios --
getFuncionarioJSON :: String -> [Funcionario]
getFuncionarioJSON path = do
  let file = unsafePerformIO (B.readFile path)
  let decodedFile = decode file :: Maybe [Funcionario]
  Data.Maybe.fromMaybe [] decodedFile

-- Salva um novo Funcionario no arquivos de Funcionarios --
saveFuncionarioJSON :: String -> String -> IO ()
saveFuncionarioJSON identificador nome = do
  let p = Funcionario identificador nome
  let newFuncionarioList = getFuncionarioJSON "app/DataBase/Funcionario.json" ++ [p]

  saveAlteracoesFuncionario newFuncionarioList

-- Pega um funcionário por id
getFuncionarioByID :: String -> [Funcionario] -> Funcionario
getFuncionarioByID _ [] = Funcionario "-1" ""
getFuncionarioByID identifierS (x : xs)
  | Models.Funcionario.identificador x == identifierS = x
  | otherwise = getFuncionarioByID identifierS xs

-- Remove um funcionário por id
removeFuncionarioByID :: String -> [Funcionario] -> [Funcionario]
removeFuncionarioByID _ [] = []
removeFuncionarioByID identifierS (x : xs)
  | Models.Funcionario.identificador x == identifierS = xs
  | otherwise = x : (removeFuncionarioByID identifierS xs)

-- Recebe uma lista com os funcionários alterados e persiste ela
saveAlteracoesFuncionario :: [Funcionario] -> IO ()
saveAlteracoesFuncionario funcionarioList = do
  B.writeFile "../Temp.json" $ encode funcionarioList
  removeFile "app/DataBase/Funcionario.json"
  renameFile "../Temp.json" "app/DataBase/Funcionario.json"

{- ==== MÉTODOS PARA BANCO  DE COMPRAS ==== -}
-- Pega todo histórico --
getCompraJSON :: String -> [Compra]
getCompraJSON path = do
  let file = unsafePerformIO (B.readFile path)
  let decodedFile = decode file :: Maybe [Compra]
  Data.Maybe.fromMaybe [] decodedFile

-- Add compra ao histórico --
saveCompraJSON :: Compra -> IO ()
saveCompraJSON compra = do
  let compraList = getCompraJSON "app/DataBase/Historico.json" ++ [compra]

  B.writeFile "../Temp.json" $ encode compraList
  removeFile "app/DataBase/Historico.json"
  renameFile "../Temp.json" "app/DataBase/Historico.json"