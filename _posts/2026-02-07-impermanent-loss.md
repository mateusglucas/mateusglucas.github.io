---
layout: post
title:  "Impermanent loss"
date:   2026-02-07 23:48:17 -0300
render_with_liquid: false
---

A compra e venda de ativos financeiros (moedas, criptomoedas, ações, etc.) geralmente funciona da seguinte forma: em uma plataforma de negociação, gerenciada por uma Exchange, há um livro de ordens, contendo todas as ordens em aberto de compra e venda. Caso você queira comprar um ativo, pode "casar" com alguma ordem de venda em aberto, realizando a transação, ou abrir uma nova ordem de compra no livro de ordens e aguardar que ela seja "casada" por algum vendedor interessado. O mesmo ocorre caso você queira vender.

Note que tudo ocorre centralizado, na Exchange que gerencia o livro de ordens, e se não houverem compradores nem vendedores interessados com ordens em aberto, não é possível realizar transações. A liquidez do mercado, neste caso, depende da existência de ordens em aberto no livro de ordens.

Com o advento das criptomoedas, com foco na descentralização financeira (DeFi), uma nova filosofia surgiu com os *Automatic Market Makers* (AMM), um tipo de Exchange descentralizada (DEX). Ao invés de depender de ordens de compradores e vendedores, AMMs se baseiam em *pools* de liquidez e em um algoritmo claro para realizar as transações de compra e venda.

Em sua forma mais básica, um *pool* de liquidez armazena um par de criptoativos A e B e permite que sejam realizadas trocas (*swaps*) automaticamente, sem necessidade de um livro de ordens. 

Os *swaps* são feitos de forma a manter inalterado o produto entre a quantidade de *tokens* A ($n_A$) e a quantidade de *tokens* B ($n_B$) no *pool*. Por exemplo, se $n_A=90$, $n_B=100$ e um usuário deseja fazer um *swap* de 100 *tokens* A ($\Delta n_A$) por *tokens* B, a quantidade $\Delta n_B$ de *tokens* B que ele irá receber em troca dos *tokens* A depositados no *pool* é determinada por:
$$
\begin{gather}
(n_{A}+\Delta n_{A})\cdot(n_{B}-\Delta n_{B})=n_{A}\cdot n_{B}=90\cdot 100=9000 \\
100-\Delta n_{B}=\frac{9000}{90+100} \\ \\
\Delta n_{B}=100-\frac{9000}{190}\approx 52.63
\end{gather}
$$
Em outras palavras, *swaps* são feitos de forma a respeitar a fórmula de produto constante $n_A\times n_B=k$. O *swap* descrito anteriormente é ilustrado na figura abaixo, em que a curva em azul representa os pontos que satisfazem o produto constante. 

```tikz
\usepackage{tikz}
\usepackage{pgfplots}
\usetikzlibrary{arrows.meta}

\begin{document}
	\begin{tikzpicture}
	  \begin{axis}[
	    xlabel=\(n_A\),
	    ylabel=\(n_B\),
	    xmin=0, xmax=300,
	    ymin=0, ymax=300,
	    axis lines=middle,
	    grid=major,
	    width=8cm,
	    height=8cm
	  ]
	  \addplot[blue, thick, domain=30:300, samples=50]{9000/x};
	  \addplot[red, thick, domain=90:190, samples=50, -{Latex[scale=1.5]}]{9000/x};
	  \node[label={1},circle,fill,red,inner sep=2pt] at (90,100) {};
	  \node[label={2},circle,fill,red,inner sep=2pt] at (190,9000/190) {};	  
	  \end{axis}
	\end{tikzpicture}
\end{document}
```

Além do *swap*, é possível prover ou retirar liquidez do *pool*. Neste caso, a constante *k* do *pool* é modificada. Para prover liquidez, o usuário deposita no *pool* quantidades $m_A$  e $m_B$ dos *tokens* A e B, respeitando a proporção $n_A$ e $n_B$ de *tokens* no *pool*, isto é:
$$
\frac{m_{A}}{m_{B}}=\frac{n_{A}}{n_{B}}\tag{1}
$$
Em troca, o usário recebe uma quantidade $m_{LT}$ de ***tokens* de liquidez**, dada por:
$$
m_{LT} = n_{LT}\cdot \frac{m_{A}}{n_{A}}=n_{LT}\cdot \frac{m_{B}}{n_{B}}
$$
Em que $n_A$ e $n_B$ são as quantidades totais de *tokens* A e B no *pool* e $n_{LT}$ é a quantidade total de *tokens* de liquidez existentes **antes** do depósito de liquidez. As novas quantidades $n_X^\prime$ de cada *token* ($X=A,B,LT$) **após** o depósito de liquidez são dadas por:
$$
n_{X}^\prime = n_{X} + m_{X}
$$
Note que ao prover liquidez ao *pool*, são **criados** (*minted*) *tokens* de liquidez.

Ao retirar liquidez do *pool*, o usuário entrega uma quantidade $m_{LT}$ de *tokens* de liquidez, que são **queimados** (*burned*), e em troca recebe quantidades $m_A$ e $m_B$ de *tokens* A e B dadas por:
$$
\begin{gather}
m_{A} = \frac{m_{LT}}{n_{LT}}\cdot n_{A} \\ \\
m_{B} = \frac{m_{LT}}{n_{LT}}\cdot n_{B}
\end{gather}
$$
Em que $n_A$ e $n_B$ são as quantidades totais de *tokens* A e B no *pool* e $n_{LT}$ é a quantidade total de *tokens* de liquidez existentes **antes** da retirada de liquidez. As novas quantidades $n_X^\prime$ de cada *token* ($X=A,B,LT$) **após** a retirada de liquidez são dadas por:
$$
n_{X}^\prime = n_{X} - m_{X}
$$
Note que $n_A$ e $n_B$ se referem sempre à quantidade de *tokens* A e B no *pool* de liquidez, enquanto $n_{LT}$ é a quantidade **total** de *tokens* de liquidez em circulação referentes ao *pool*.

Vamos observar como varia $k$ após ser provida ou retirada liquidez ao *pool*. Sendo $k^\prime$ a constante do *pool* após ser provida ou retirada liquidez:
$$
\begin{align}
k^\prime = n_{A}^\prime\cdot n_{B}^\prime&=(n_{A}+m_{A})\cdot(n_{B}+m_{B}) \\
&=n_{A}\cdot n_{B}+n_{A}\cdot m_{B}+n_{B}\cdot m_{A}+m_{A}\cdot m_{B}
\end{align}
$$
Dividindo ambos os lados por $k=n_A\cdot n_B$:
$$
\frac{k^\prime}{k} = 1 + \frac{m_{B}}{n_{B}}+\frac{m_{A}}{n_{A}}+\frac{m_{A}\cdot m_{B}}{n_{A}\cdot n_{B}}
$$
Mas note que:
$$
\frac{m_{A}}{n_{A}}=\frac{m_{B}}{n_{B}}=\frac{m_{LT}}{n_{LT}}
$$
Logo:
$$
\begin{align}
\frac{k^\prime}{k} &= 1 + 2\cdot \frac{m_{LT}}{n_{LT}}+\left( \frac{m_{LT}}{n_{LT}} \right)^2=\left( 1+\frac{m_{LT}}{n_{LT}} \right)^2 \\
&=\left( \frac{n_{LT}+m_{LT}}{n_{LT}} \right)^2=\left( \frac{n_{LT}^\prime}{n_{LT}} \right)^2
\end{align}
$$
Portanto:
$$
\frac{{n_{LT}}^2}{k}=\frac{{n_{LT}^\prime}^2}{k^\prime}=K
$$
Sendo assim, a constante $k$ do *pool* e a o quadrado da quantidade total $n_{LT}$ de *tokens* de liquidez estão intimamente relacionadas por uma constante de proporção $K$. Esta constante é definida no momento da criação do *pool*. É natural que queiramos fazer $K=1$. Para isso, no momento da criação do *pool*, basta gerarmos uma quantidade de *tokens* de liquidez igual a $n_{LT_{0}} = \sqrt{n_{A_{0}}\cdot n_{B_{0}}}=\sqrt{k_{0}}$, em que $n_{A_0}$ e $n_{B_0}$ são as quantidades de *tokens* A e B depositadas para a criação do *pool*. Sendo assim, teremos sempre $n_{LT}=\sqrt{ k }$.

Ao fornecer liquidez ao *pool*, o usuário recebe uma parcela das taxas de transação cobradas nos *swaps*, de acordo com o tamanho da sua participação no *pool*. Então, em um primeiro momento, fornecer liquidez ao *pool* parece muito mais vantajoso do que realizar *buy-and-hold* nos tokens A e B. Entretanto, a variação relativa de preço entre os tokens A e B causa uma **perda impermanente** (*impermanent loss*) em relação ao *buy-and-hold*, consolidada caso o usuário retire liquidez do *pool*. Vejamos como isso ocorre.

Primeiramente, note que em um mercado eficiente, o *pool* sempre armazena exatamente metade de seu valor em cada um dos *tokens*. Caso exista um desequilíbrio, a arbitragem fará com que o equilíbrio se restabeleça. Portanto, sendo $p_A$ e $p_B$ os preços dos *tokens* A e Bem relação a alguma moeda fiduciária de referência, temos:
$$
n_{A}\cdot p_{A}=n_{B}\cdot p_{B}\tag{2}\implies \frac{p_{A}}{p_{B}}=\frac{n_{B}}{n_{A}}
$$
Com base em $(2)$, definamos:
$$
\begin{align}
p_{AB}=\frac{p_{A}}{p_{B}}=\frac{n_{B}}{n_{A}} \\ \\
p_{BA}=\frac{p_{B}}{p_{A}}=\frac{n_{A}}{n_{B}} 
\end{align}\tag{3}
$$
Note que $p_{AB}$ representa o preço do *token* A cotado em *token* B. Se as relações parecerem invertidas para você, veja que $p_{AB}$ indica quantos *tokens* B são necessários para comprar um *token* A.

Vamos denotar com um índice zero as grandezas no momento em que o usuário provê liquidez ao *pool*. Grandezas sem índice correspondem ao momento em que o usuário retira liquidez do *pool* ou a grandezas que se mantêm inalteradas em ambos os momentos. Para cotações, vamos escolher como referência o *token* A.

Como dito anteriormente, ao prover liquidez ao *pool*, o usuário recebe uma quantidade de *tokens* de liquidez dada por $m_{LT} = n_{LT_{0}}\cdot \frac{m_{A_{0}}}{n_{A_{0}}}=n_{LT_{0}}\cdot \frac{m_{B_{0}}}{n_{B_{0}}}$.  O valor total inicial investido pelo usuário é dado por:
$$
M_{0}=m_{A_{0}}\cdot p_{A_{0}} + m_{B_{0}}\cdot p_{B_{0}}
$$
Em algum momento do futuro, caso o usuário retire toda a liquidez provida anteriormente, ele receberá quantidades de *tokens* A dada por:
$$
m_{A} = \frac{m_{LT}}{n_{LT}}\cdot n_{A}=\frac{n_{LT_{0}}\cdot \frac{m_{A_{0}}}{n_{A_{0}}}}{n_{LT}}\cdot n_{A}=m_{A_{0}}\cdot \frac{n_{LT_{0}}}{n_{LT}}\cdot \frac{n_{A}}{n_{A_{0}}} \\
$$
Lembrando que $n_{LT}=\sqrt{ k }=\sqrt{ n_{A}\cdot n_{B} }$ :
$$
m_{A} =m_{A_{0}}\cdot \frac{\sqrt{ n_{A_{0}}\cdot{n_{B_{0}}}} }{\sqrt{ n_{A}\cdot n_{B}} }\cdot \frac{n_{A}}{n_{A_{0}}}=m_{A_{0}}\cdot \sqrt{ \frac{n_{A}\cdot n_{B_{0}}}{n_{A_{0}}\cdot n_{B}} } =m_{A_{0}}\cdot \sqrt{ \frac{\frac{n_{B_{0}}}{n_{A_{0}}}}{\frac{n_{B}}{n_{A}}}}=m_{A_{0}}\cdot \sqrt{ \frac{p_{AB_{0}}}{p_{AB}} }\\
$$
Analogamente:
$$
m_{B}=m_{B_{0}}\cdot \sqrt{ \frac{p_{BA_{0}}}{p_{BA}} } \\
$$
O valor recuperado no futuro, no cenário em que o usuário forneceu liquidez ao *pool*, é dado por:
$$
M_{LP}=m_{A}\cdot p_{A}+m_{B}\cdot p_{B}=m_{A_{0}}\cdot p_{A}\cdot\sqrt{ \frac{p_{AB_{0}}}{p_{AB}} }+m_{B_{0}}\cdot p_{B}\cdot \sqrt{ \frac{p_{BA_{0}}}{p_{BA}} }
$$
Caso o usuário tivesse feito *buy-and-hold*, a quantidade de *tokens* A e B se manteria inalterada. Neste caso, o valor do recuperado no futuro seria:
$$
M_{BH}=m_{A_{0}}\cdot p_{A}+ m_{B_{0}}\cdot p_{B}
$$
A **perda impermanente** (*impermanent loss*) L representa a perda do cenário do *pool* em relação ao cenário *buy-and-hold*, sendo dada por:
$$
L=\frac{M_{LP}}{M_{BH}}-1
$$
Primeiro vamos calcular a razão $\frac{M_{LP}}{M_{BH}}$. Notemos que esta razão pode ser decomposta em duas parcelas, em que uma pode ser obtidas a partir da outra ao trocar A por B. Estas parcelas serão representadas como $\gamma_{AB}$ e $\gamma_{BA}$, conforme indicado abaixo:
$$
\begin{align}
\frac{M_{LP}}{M_{BH}}&=\frac{m_{A_{0}}\cdot p_{A}\cdot\sqrt{ \frac{p_{AB_{0}}}{p_{AB}} }+m_{B_{0}}\cdot p_{B}\cdot \sqrt{ \frac{p_{BA_{0}}}{p_{BA}} }}{m_{A_{0}}\cdot p_{A}+ m_{B_{0}}\cdot p_{B}} \\ \\
&={\color{orange}\underbrace{\color{var(--text-normal)}\frac{m_{A_{0}}\cdot p_{A}\cdot\sqrt{ \frac{p_{AB_{0}}}{p_{AB}} }}{m_{A_{0}}\cdot p_{A}+ m_{B_{0}}\cdot p_{B}}}_{\gamma_{AB}}}+{\color{orange}\underbrace{\color{var(--text-normal)}\frac{m_{B_{0}}\cdot p_{B}\cdot \sqrt{ \frac{p_{BA_{0}}}{p_{BA}} }}{m_{B_{0}}\cdot p_{B}+ m_{A_{0}}\cdot p_{A}}}_{\gamma_{BA}}}
\end{align}
$$
Desenvolvendo $\gamma_{AB}$:
$$
\gamma_{AB}=\frac{m_{A_{0}}\cdot p_{A}\cdot \sqrt{ \frac{p_{AB_{0}}}{p_{AB}} }}{m_{A_{0}}\cdot p_{A}+m_{B_{0}}\cdot p_{B}}=\frac{1}{1+\frac{m_{B_{0}}\cdot p_{B}}{m_{A_{0}\cdot p_{A}}}}\cdot \sqrt{ \frac{p_{AB_{0}}}{p_{AB}} }
$$Aplicando $(1)$, $(2)$ e $(3)$:
$$
\gamma_{AB}=\frac{1}{1+\frac{p_{AB_{0}}}{p_{AB}}}\cdot \sqrt{ \frac{p_{AB_{0}}}{p_{AB}} }=\frac{1}{\sqrt{ \frac{p_{AB}}{p_{AB_{0}}} }+\sqrt{ \frac{p_{AB_{0}}}{p_{AB}} }}=\frac{1}{\sqrt{ \frac{p_{AB}}{p_{AB_{0}}} }+\sqrt{ \frac{p_{BA}}{p_{BA_{0}}} }}
$$
Note que $\gamma_{AB}$ é simétrica em relação a A e B, i.e., trocando A por B e vice-e-versa, chega-se à mesma expressão. Logo $\gamma_{AB}$ e $\gamma_{BA}$ são iguais (isso pode ser deduzido também pelo fato de que $m_{A}\cdot p_{A}=m_{B}\cdot p_{B}$, o que é consequência de $(1)$ e $(2)$). Sendo $\gamma=\gamma_{AB}=\gamma_{BA}$ e usando o fato de que $p_{AB}=\frac{1}{p_{BA}}$:
$$
\frac{M_{LP}}{M_{BH}}=\gamma_{AB}+\gamma_{BA}=2\cdot\gamma=\frac{2}{\sqrt{ \frac{p_{AB}}{p_{AB_{0}}} }+\sqrt{ \frac{p_{AB_{0}}}{p_{AB}} }}
$$
Sendo $\alpha=\frac{p_{AB}}{p_{AB_{0}}}$ a variação relativa de preço do *token* A em relação ao *token* $B$:
$$
\frac{M_{LP}}{M_{BH}}=\frac{2}{\sqrt{ \alpha }+\sqrt{ \frac{1}{\alpha}}}=\frac{2}{\sqrt{\alpha }+\frac{1}{\sqrt{ \alpha }}}\tag{4}
$$
Note que, como $\gamma$ é simétrico em relação a A e B, a razão $\frac{M_{LP}}{M_{BH}}=2\cdot\gamma$ também será. Como consequência,  se definíssemos $\alpha$ como a variação relativa do *token* B em relação ao *token* A, chegaríamos à mesma expressão.

Finalmente, chegamos à expressão da perda impermanente:
$$
L=\frac{M_{LP}}{M_{BH}}-1=\frac{2}{\sqrt{ \alpha }+\frac{1}{\sqrt{ \alpha }}}-1
$$
Ou da forma mais comumente apresentada:
$$
\boxed{L=\frac{2\sqrt{ \alpha }}{1+\alpha}-1}\tag{5}
$$

Traçando o gráfico da perda impermanente com o eixo $x$ em escala logarítmica, a simetria entre as variações relativas de preço entre os *tokens* A e B fica evidente.

```tikz
\usepackage{tikz}
\usepackage{pgfplots}

\begin{document}
	\begin{tikzpicture}
	  \begin{axis}[
	    xlabel=\(\alpha\),
	    ylabel=\(L\),
	    axis lines=middle,
	    grid=major,
	    xmode=log,
	    width=12cm,
	    height=8cm
	  ]
	    \addplot[blue, thick, domain=1e-2:1e2, samples=50]{2/(sqrt(x)+1/sqrt(x))-1};
	  \end{axis}
	\end{tikzpicture}
\end{document}
```
