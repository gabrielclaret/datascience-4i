# ===============================================================================================
# Curso: Introdução à Ciência de Dados e Decisões 


# Aula  - Redes Neurais Artificiais

# Professor - Ricardo Augusto


# =========================
# Exercicio Computacional 1

# Objetivo: implementar modelos de redes neurais artificiais


# Carregamento de dataset do R
library(ggplot2)
library(MASS)
library(readxl)
library(caTools)
library(neuralnet)


# Verificação do Caminho do direatório
# setwd("C:/Users/1513 X-MXTI/Desktop/Projeto 4I Machine Learning Classes/Aula 4 - Redes Neurais Artificiais/2 - Lista de Atividades/Exerc�?cios Computacionais/Exerc�?cio Computacional - 1/R")
# getwd()
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
getwd()

# Use o comando list.files() para verificar os arquivos presentes no diretório
list.files()

# Importação de Arquivos Excel
table = read.csv("hfdataset.csv")


# Gravação e leitura de arquivos .csv
# write.csv(boston_table,'boston_tabela_csv.csv')
# boston_table_csv = read.csv('boston_tabela_csv.csv',sep = ',')
# View(boston_table_csv)

# Semente aleatória para geração dos mesmos resultados
set.seed(101)

str(table)
# S�?ntese estat�?stica (primeiro/terceiro quartis, mediana, m�?nimo/máximo) dos dados
summary(table)

# Verificando se existe algum 'na' na importação
any(is.na(table))

# Conjunto de Dados (data set)
dados = table

# Visualização dos Dados
# View(dados) 

# =========================================================================================
# Pré-processamento do Dados

# Realizar o pré-processamento dos dados é uma boa prática em Redes Neurais Artificiais
# Não realizar a normalização dos dados (tipo de pré-processamento) é algo que pode dificultar
# o processo de treinamento (vimos isso nas aulas anteriores). De fato, o que ocorre é a 
# dificuldade de convergência do algoritmo de aprendizagem ao buscar a minimização da função custo
# quando os dados estão em escalas muito diferentes.

# Com isso, podemos fazer a normalização da média (z) ou a min/max, por exemplo. 

# Procedimento de Normalização min/max - vamos capturar os valores máximo e m�?nimo dos dados
maximo <- apply(dados, 2, max) 
minimo <- apply(dados, 2, min)

# Dica:
# i) é importante observar atentamente cada variável explanatória do dataset para aplicarmos a 
# função apply ao conjunto de dados inteiro. 

# Imprimindo os valores
maximo
minimo

# Aplicando a normalização min/max (função scale - pacote RBase)
dados_normalizados <- as.data.frame(scale(dados, center = minimo, scale = maximo - minimo))
head(dados_normalizados)
View(dados_normalizados)
# =====================================================================================
# Fazendo a divisão dos dados em conjuntos de treinamento e teste

# Aplicando a função sample.split (pacote caTools) para divisão dos dados
# O sample.split é mais uma maneira de gerarmos �?ndices para, posteriormente, 
# acessarmos o dataset e realizamos a divisão treino/teste
divisao_dados = sample.split(dados_normalizados$diabetes, SplitRatio = 0.70)
# View(divisao_dados)


# Acessando o conjunto de dados de treinamento com a função subset
dados_norm_treinamento = subset(dados_normalizados, divisao_dados == TRUE)
dados_norm_teste       = subset(dados_normalizados, divisao_dados == FALSE)

# Visualização dos dados de treinamento e teste
# View(dados_norm_treinamento)
# View(dados_norm_teste)

# Verificação das dimensões
dim(dados_norm_treinamento)
dim(dados_norm_teste)


# ==================================================================================================================
# Fazendo o Treinamento do Modelo de Rede Neural Artificial


# Capturando os nomes das colunas
nomes_colunas <- colnames(dados_norm_treinamento)
nomes_colunas

# Vamos usar os nomes das variáveis explanatórias na montagem do objeto do tipo fórmula do R
equation_model <- as.formula(paste ( "diabetes ~ ", paste(nomes_colunas[!nomes_colunas %in% "diabetes"], collapse = " + ")))
equation_model

# Treinamento com NeuralNet - repare estamos 
modelo_RNA = neuralnet(equation_model, data = dados_norm_treinamento, hidden = c(5,3), linear.output = TRUE)
modelo_RNA

# Dicas:
# Objetivo da função: Train neural networks using backpropagation, 
# resilient backpropagation (RPROP) with (Riedmiller, 1994) or 
# without weight backtracking (Riedmiller and Braun, 1993) or 
# the modified globally convergent version (GRPROP) by Anastasiadis et al. (2005). 

# The function allows flexible settings through custom-choice of error and activation function.

# formula	-> a symbolic description of the model to be fitted.

# hidden  -> a vector of integers specifying the number of hidden neurons (vertices) in each layer

# Visualização da Arquitetura da Rede Neural Artificial no R
plot(modelo_RNA)

# ==========================================================
# Fazendo predições com a rede neural treinada 

# Vamos usar a função compute (do pacote neural net)
RNA_pred_norm = compute(modelo_RNA, dados_norm_teste[1:13])
RNA_pred_norm

# É importante notar que as predições foram obtidas a partir dos dados de teste normalizados. 
# Precisamos fazer a conversão de normalização necessária para acessar os valores previstos de interesse


# Como fazer a conversão de normalização no caso de min/max

# 1) Acessamos a rede neural treinada e seu resultado ($net.result)
# 2) Acessamos os valores da variável de sa�?da (diabetes) 
# 3) Multiplicamos os resultados normalizados pela diferença entre o máximo e o m�?nimo - e acrescentamos o m�?nimo
max_diabetes = max(dados$diabetes) 
min_diabetes = min(dados$diabetes) 
RNA_pred = RNA_pred_norm$net.result*(max_diabetes - min_diabetes) + min_diabetes
# View(RNA_pred_norm)

# Vamos fazer o mesmo procedimento para os dados de teste normalizados
dados_teste <- (dados_norm_teste$diabetes)*(max(dados$diabetes) - min(dados$diabetes)) + min(dados$diabetes)
dados_teste

# ----------------------------------------------------------------------------
# Estimativa do Erro Quadrático Médio (MSE - Mean Squared Error) do Modelo RNA
MSE_RNA <- sum(     ((dados_teste - RNA_pred)^2) )/nrow(RNA_pred)
MSE_RNA

# Obtendo os erros de previsao
df_RNA_pred <- data.frame(dados_teste, RNA_pred)
# head(df_RNA_pred)

# Plot dos erros
ggplot(df_RNA_pred, aes(x = dados_teste,y = RNA_pred)) + 
            geom_point() + 
            stat_smooth() + 
            xlab('Dados de Teste (preço mediano das casas)') + 
            ylab('Predições')  +
            ggtitle("Gráfico de Desempenho - Modelo RNA")

