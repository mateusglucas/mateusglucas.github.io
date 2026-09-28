---
layout: post
title:  "Axiomas de Peano - Da necessidade do Princípio da Indução"
date:   2026-09-28 18:00:00 -0300
categories: notes
render_with_liquid: false
---

Intuitivamente, todos nós sabemos o que são os números naturais e como contá-los. Talvez este seja um dos primeiros conceitos matemáticos que aprendemos. Na Matemática, esta intuição é formalizada por meio dos Axiomas de Peano.

Aos que já estão habituados com o tema, um desses axiomas é o chamado Princípio da Indução. Apesar de ser um axioma muito útil para demonstrações, sua necessidade pode não ser muito clara à primeira vista. Além disso, este axioma é equivalente a um outro axioma, o Princípio da Boa Ordenação. 

Neste artigo irei apresentar os Axiomas de Peano a partir da intuição que já possuímos sobre os números naturais e apresentarei a necessidade de admitirmos o Princípio da Indução ou o da Boa Ordenação. Por fim, ao apresentar esta necessidade, espero trazer uma intuição clara da equivalência entre esses dois axiomas. 

Tomemos como objetos já conhecidos um conjunto $\mathbb{N}$, chamado de (sim, você já deve imaginar) *conjunto dos números naturais* e uma função $s:\mathbb{N}\to\mathbb{N}$, chamada de *sucessor*. Que propriedades esses dois objetos possuem que caracterizam completamente a noção intuitiva que possuímos dos números naturais? Primeiramente, notamos que existe um elemento que não é sucessor de nenhum outro número natural, pelo qual sempre iniciamos as contagens, nosso bom e velho *um*.

>[!info]
>Há uma controvérsia sobre incluir ou não o $0$ no conjunto dos números naturais. Como aqui estamos abordando-os como uma estrutura utilizada para contagem, é mais coerente iniciarmos pelo $1$ (a não ser que você conte $0, 1, 2, \dots$).

Temos então nosso primeiro axioma:

**P1.**  Existe um *único* número natural, representado pelo símbolo $1$, que não é sucessor de nenhum outro número natural.

Outra propriedade importante é a de que dois números naturais diferentes possuem sucessores diferentes, i.e., se $m,n\in\mathbb{N}$ com $m\neq n$, então $s(m)\neq s(n)$. De maneira equivalente, se dois números naturais possuem o mesmo sucessor, então eles são iguais, i.e., se $s(m)=s(n)$, então $m=n$. Esta propriedade é chamada de *injetividade*. Sendo assim, podemos definir nosso segundo axioma:

**P2.** $s:\mathbb{N}\to\mathbb{N}$ é *injetiva*.

Pelos axiomas que definimos, garantimos, pelo menos, a existência do número $1$. Partindo de $1$, vamos aplicar a função $s$ sucessivamente. Como $1$ não é sucessor de nenhum número (axioma **P1**), então, $s(1)\neq 1$. Logo $s(1)$, o sucessor de $1$, é um número natural distinto de $1$, que representaremos (advinhem!) pelo símbolo $2$. 

E quanto a $s(2)$? Há garantia, pelos axiomas definidos até o momento, que ele será um número natural distinto de $1$ e $2$? A resposta é **sim**. Temos que $s(2)\neq 1$, pois $1$ não é o sucessor de nenhum outro número, e também que $s(2)\neq2$, pois, caso contrário, teríamos $s(2)=2=s(1)$, contrariando a injetividade de $s$. Representaremos $s(2)$ pelo símbolo (isto está começando a ficar repetitivo) $3$.

Usando estes mesmos argumentos, podemos concluir que, partindo de $1$ e tomando o sucessor repetidamente, sempre obtemos números naturais distintos. Sendo assim, os axiomas que definimos garantem a existência da estrutura de números naturais que conhecemos.

Isso é tudo pessoal!

Não tão rápido... Vamos criar um diagrama do que temos até agora, em que as flechas representam a aplicação da função sucessor:

```tikz
\tikzstyle{item} = [circle, text centered, draw=black]
\tikzstyle{arrow} = [thick, ->, >=stealth]
\begin{document}
  \begin{tikzpicture}
    \def\N{5}
    \def\delta{2}
	\foreach \x in {1, ..., \N}
	    \node(\x)[item] at ({\delta * (\x-1)}, 0) {\x};
	
	\node(dots)[item, draw=none] at ({\delta * \N}, 0) {...};

	\pgfmathtruncatemacro{\M}{\N-1}
	\foreach \x in {1, ..., \M}
		\pgfmathtruncatemacro{\y}{\x+1}
	    \draw[arrow](\x) -- (\y);
	    
	\draw[arrow](\N) -- (dots);
  \end{tikzpicture}
\end{document}
```

Pelo axioma **P1**, nenhuma flecha pode chegar em $1$. Pelo axioma **P2**, uma e somente uma flecha chega em todos os outros números naturais. Os axiomas produziram a nossa estrutura familiar de números naturais, mas há algo a mais que não estamos percebendo? Vamos desenhar mais um numero natural arbitrário, representado por $\alpha$.

```tikz
\tikzstyle{item} = [circle, text centered, draw=black]
\tikzstyle{arrow} = [thick, ->, >=stealth]
\begin{document}
  \begin{tikzpicture}
    \def\N{5}
    \def\delta{2}
	\foreach \x in {1, ..., \N}
	    \node(\x)[item] at ({\delta * (\x-1)}, 0) {\x};
	
	\node(dots)[item, draw=none] at ({\delta * \N}, 0) {...};

	\pgfmathtruncatemacro{\M}{\N-1}
	\foreach \x in {1, ..., \M}
		\pgfmathtruncatemacro{\y}{\x+1}
	    \draw[arrow](\x) -- (\y);
	    
	\draw[arrow](\N) -- (dots);

	\node(alpha)[item] at({\delta *\N/2}, -\delta) {$\alpha$};
	\node(dotsleft)[item, draw=none] at({\delta*\N/2-\delta}, -\delta) {...};
	\node(dotsright)[item, draw=none] at({\delta*\N/2+\delta}, -\delta) {...};
	\draw[arrow](dotsleft) -- (alpha); 
	\draw[arrow](alpha) -- (dotsright);
  \end{tikzpicture}
\end{document}
```

Pela nossa intuição sobre os números naturais, partindo de $1$ devemos chegar, em algum momento, no número $\alpha$, i.e., $\alpha$ deve pertencer ao ramo gerado por $1$.  Mas, e se tivermos isso?

```tikz
\tikzstyle{item} = [circle, text centered, draw=black]
\tikzstyle{arrow} = [thick, ->, >=stealth]
\begin{document}
  \begin{tikzpicture}
	\node(alpha)[item] {$\alpha$};
	\draw[arrow](alpha) edge [in=150, out=30, looseness=10] (alpha); 
  \end{tikzpicture}
\end{document}
```

Ou isso?


```tikz
\tikzstyle{item} = [circle, text centered, draw=black]
\tikzstyle{arrow} = [thick, ->, >=stealth]
\begin{document}
  \begin{tikzpicture}
	\def\r{1}
	\node(alpha)[item] at (-\r, 0) {$\alpha$};
	\node(beta)[item] at (\r, 0) {$\beta$};

	\draw[arrow] (alpha) edge[bend left] (beta);
	\draw[arrow] (beta) edge[bend left] (alpha);
  \end{tikzpicture}
\end{document}
```

Ou isso?


```tikz
\tikzstyle{item} = [circle, text centered, draw=black]
\tikzstyle{arrow} = [thick, ->, >=stealth]
\begin{document}
  \begin{tikzpicture}
	\def\r{1}
	\node(alpha)[item] at (0, \r) {$\alpha$};
	\node(beta)[item] at ({\r*cos(-30)}, {\r*sin(-30)}) {$\beta$};
	\node(gamma)[item] at ({\r*cos(210)}, {\r*sin(210)}) {$\gamma$};

	\draw[arrow] (alpha) edge[bend left] (beta);
	\draw[arrow] (beta) edge[bend left] (gamma);
	\draw[arrow] (gamma) edge[bend left] (alpha);
  \end{tikzpicture}
\end{document}
```

Ou uma mistura desses casos?

```tikz
\tikzstyle{item} = [circle, text centered, draw=black]
\tikzstyle{arrow} = [thick, ->, >=stealth]
\begin{document}
  \begin{tikzpicture}
	\def\r{1}
	\def\sep{5}
	\node(alpha)[item] at (-\r, 0) {$\alpha$};
	\node(beta)[item] at (\r, 0) {$\beta$};

	\draw[arrow] (alpha) edge[bend left] (beta);
	\draw[arrow] (beta) edge[bend left] (alpha);

	\node(gamma)[item] at (\sep, \r) {$\gamma$};
	\node(delta)[item] at ({\sep+\r*cos(-30)}, {\r*sin(-30)}) {$\delta$};
	\node(epsilon)[item] at ({\sep+\r*cos(210)}, {\r*sin(210)}) {$\epsilon$};

	\draw[arrow] (gamma) edge[bend left] (delta);
	\draw[arrow] (delta) edge[bend left] (epsilon);
	\draw[arrow] (epsilon) edge[bend left] (gamma);
  \end{tikzpicture}
\end{document}
```

Ou ainda um ramo que, a partir de $\alpha$, segue infinitamente em ambas as direções, sem nunca encontrar o ramo gerado por $1$?

Não há nada nos dois axiomas que definimos que garanta ou impeça a existência desses números naturais "estranhos". Considerando os axiomas que definimos até agora, a existência dos números naturais "estranhos" é indecidível.

Para resolver o problema, vamos forçar a barra e definirmos um axioma que simplesmente diz que o conjunto dos números naturais é somente o ramo gerado por $1$. Note que, para que um conjunto $X\subset\mathbb{N}$ contenha todos os elementos do ramo gerado por $1$, basta requerer que $1\in X$ e que, para qualquer elemento $n\in X$, tenhamos também $s(n)\in X$. Podemos agora enunciar o:

**P3a.** (Princípio da Indução) Se $X\subset\mathbb{N}$ é um conjunto tal que:
- $1\in X$
- se $n\in X$, então $s(n)\in X$
Então $X=\mathbb{N}$.

Pode parecer que isso não elimina completamente o problema, pois, por exemplo, o conjunto formado pela união do ramo gerado por $1$ com qualquer outro ramo estranho ainda satisfaz as duas condições do axioma, i.e., é um conjunto *indutivo*. Mas o axioma diz mais do que isso, ele também exige que $\mathbb{N}$ seja o *menor* conjunto indutivo. De fato, seja $X\subset\mathbb{N}$ e $X\neq\mathbb{N}$. (i.e., um subconjunto *próprio* de $\mathbb{N}$). Se $X$ for indutivo, então, pelo Princípio da Indução, $X=\mathbb{N}$, absurdo. Logo nenhum subconjunto próprio de $\mathbb{N}$ é indutivo.

Vejamos como provar, por exemplo, que não existe um número natural $\alpha$ tal que $s(\alpha)=\alpha$ (o primeiro caso que desenhamos). Seja $X=\{ n\in\mathbb{N}~|~s(n)\neq n \}$. Sabemos que $1\in X$, pois já concluímos anteriormente que $s(1)=2\neq1$. Suponha que $n\in X$. Então $s(n)\neq n$ e, pela injetividade de $s$, segue que $s(s(n))\neq s(n)$. Logo $s(n)\in X$. Portanto, pelo Princípio da Indução, $X=\mathbb{N}$, ou seja, $s(n)\neq n$ para todo número natural, logo não pode existir $\alpha$ natural tal que $s(\alpha)=\alpha$. 

Com o Princípio da Indução, eliminamos todos os possíveis números naturais "estranhos". Mas há outras formas de fazer isso. Compare os ramos "estranhos" com o ramo gerado por $1$. Percorra os ramos, a partir de qualquer elemento, no sentido contrário das flechas. Você irá notar que, enquanto que no ramo gerado por $1$ este processo terá fim, chegando inevitavelmente no número $1$, isto não ocorre nos ramos "estranhos".  Intuitivamente, acabamos de observar que os ramos "estranhos" não possuem um *menor elemento*.

Mas, antes disso, precisamos definir o que é um *menor elemento*. Para nos auxiliar nesta tarefa, vamos primeiramente definir, de forma recursiva, a operação de adição $+:\mathbb{N}\times\mathbb{N}\to\mathbb{N}$:

- $1+m=s(m)$
- $s(n)+m=s(n+m)$

>[!info] 
>Com o auxílio do Princípio da Indução, é possível demonstrar que a adição está bem definida para todo natural. Seja $X=\{ n\in\mathbb{N}~|~ n+m\text{ é bem definido para todo } m\in\mathbb{N}  \}$. Note que $1\in X$, pois $1+m=s(m)$ para todo $m\in\mathbb{N}$. Além disso, se $n\in X$, então $n+m$ é bem definido, logo é possível obter $s(n+m)$. Então $s(n)+m$ é bem definido para todo $m\in\mathbb{N}$, pois, pela definição, é igual a $s(n+m)$. Logo $s(n)\in X$.
>
>Demonstramos que $1\in X$ e que, se $n\in X$, então $s(n)\in X$.  Portanto, pelo Princípio da Indução, temos $X=\mathbb{N}$, isto é, $n+m$ é bem definido para todo $m,n\in\mathbb{N}$.

Vamos para mais algumas definições auxiliares. Dizemos que $m<n$ ($m$ é menor que $n$) quando existe $p\in\mathbb{N}$ tal que $m+p=n$. Dizemos que $m\le n$ quando $m<n$ ou $m=n$. 

Finalmente, dado um conjunto não vazio $X\subset\mathbb{N}$, dizemos que $m\in X$ é o *menor elemento* de $X$ quando $m\le n$ para todo $n\in X$.

Como já observamos, os ramos "estranhos" são subconjuntos sem menor elemento. Além disso, o ramo gerado por $1$ ou qualquer subconjunto deste ramo possui um menor elemento. Sendo assim, outra forma de eliminar os ramos "estranhos" é por meio do:

**P3b.** (Princípio da Boa Ordenação) Todo conjunto $X\subset\mathbb{N}$ não vazio possui um *menor elemento*.

Note que tanto o Princípio da Indução quanto o Princípio da Boa Ordenação exprimem o mesmo fato de formas diferentes, de que não existem números naturais fora do ramo gerado por $1$. Enquanto o Princípio da Indução resolve o problema garantindo que o ramo gerado por $1$ é o único ramo que existe, o Princípio da Boa Ordenação garante que não há ramos em que seja possível, a partir de um elemento qualquer, caminhar indefinidamente na direção contrária das flechas, como os ramos circulares ou o ramo infinito para ambos os lados que apresentamos.

Há ainda uma terceira alternativa evidente para resolver o problema dos números "estranhos". Antes de apresentá-la, vamos definir a *diferença* entre dois conjuntos $A$ e $B$ quaisquer:
$$A-B=\{ x\in A~|~x\not\in B \}$$
Isto é, $A-B$ é o conjunto obtido ao remover de $A$ todos os elementos que pertençam a $B$.
Vamos definir também a *imagem* de um conjunto $X\subset\mathbb{N}$ por $s$:
$$s(X)=\{ s(n)\in\mathbb{N}~|~n\in X \}$$ Ou seja, $s(X)$ é o conjunto que se obtém ao aplicar $s$ em todos os elementos de $X$. 

Vamos à terceira alternativa.

Note que, aplicando $s$ a todos elementos de um ramo "estranho", obtemos novamente todos os elementos do ramo, i.e., a imagem por $s$ de um ramo "estranho" é o próprio ramo "estranho". Já para o ramo gerado por $1$ ou para qualquer subconjunto deste ramo, ao aplicarmos $s$ em todos os elementos, ao menos o menor elemento do conjunto ficará de fora da imagem. Sendo assim, podemos eliminar os ramos "estranhos" exigindo que:

**P3c.** Para todo $X\subset\mathbb{N}$ não vazio, $X-s(X)\neq \emptyset$.

Intuitivamente, os axiomas **P3a**, **P3b** e **P3c** exprimem a mesma coisa de formas diferentes, mas intuições não são suficientes. Vamos provar que de, fato, estes três axiomas são equivalentes.

Antes disso, mais algumas definições:
$$I_{n}=\{m\in\mathbb{N}~|~m\leq n \}$$
Isto é, $I_n$ é o conjunto de todos os números naturais até $n$. Por exemplo, $I_5=\{ 1,2,3,4,5 \}$.
Definamos também o *complementar* de um conjunto $X\subset\mathbb{N}$:
$$\complement X=\mathbb{N}-X=\{ n\in\mathbb{N}~|~n\not\in X \}$$
Vamos às demonstrações.

```tikz
\tikzstyle{item} = [circle, text centered, draw=black]
\tikzstyle{arrow} = [thick, ->, >=stealth]
\begin{document}
  \begin{tikzpicture}
	\def\r{1}
	\node(alpha)[item] at (0, \r) {P3a};
	\node(beta)[item] at ({\r*cos(-30)}, {\r*sin(-30)}) {P3b};
	\node(gamma)[item] at ({\r*cos(210)}, {\r*sin(210)}) {P3c};

	\draw[arrow] (alpha) edge[bend left] (beta);
	\draw[arrow] (beta) edge[bend left] (gamma);
	\draw[arrow] (gamma) edge[bend left] (alpha);
  \end{tikzpicture}
\end{document}
```

**P3a$\implies$P3b:** 

Seja $X\subset\mathbb{N}$ um conjunto sem menor elemento e seja $Y=\{ n\in\mathbb{N}~|~I_n\subset\complement X \}$. Como $X$ não possui menor elemento, então $1\not\in X$. Mas $1\not\in X\implies 1\in\complement X\implies I_1=\{ 1 \}\subset\complement X\implies 1\in Y$.

Dado um $n\in\mathbb{N}$, suponhamos que $n\in Y$. Então $I_n\subset\complement X$. Além disso, $I_n\subset\complement X\implies s(n)\not\in X$, pois, caso contrário, $s(n)$ seria o menor elemento de $X$. Portanto $I_n\subset\complement X$ e $s(n)\in\complement X$. Logo $I_{s(n)}\subset X$ e, então, $s(n)\in Y$. Sendo assim, $n\in Y\implies s(n)\in Y$.

Então, por **P3a**, segue que $Y=\mathbb{N}$, logo $I_n\subset\complement X$ para todo $n\in\mathbb{N}$. Em particular, $n\in\complement X$ para todo $n\in\mathbb{N}$, ou seja, $n\not\in X$ para todo $n\in\mathbb{N}$. Logo $X=\emptyset$.

**P3b$\implies$P3c:** 

Seja $X\subset\mathbb{N}$ não vazio e seja $n$ o menor elemento de $X$. Suponhamos que $X-s(X)=\emptyset$. Então todo elemento de $X$ também pertence a $s(X)$. Em particular, $n\in s(X)$, logo existe $m\in X$ tal que $s(m)=n$. Mas isso implica que $m<n$. Absurdo, pois $n$ é o menor elemento de $X$. Portanto $X-s(X)=\emptyset$.

**P3c$\implies$P3a:** 

Seja $X\subset \mathbb{N}$ tal que:
- $1\in X$
- $n\in X\implies s(n)\in X$
Suponhamos que $\complement X\neq\emptyset$. Logo, por **P3c**, temos $\complement X-s(\complement X)\neq\emptyset$. Portanto existe $p\in\complement X - s(\complement X)$, i.e., existe $p\in\mathbb{N}$ tal que $p\not\in X$ e $p\not\in s(\complement X)$. Como $p\not\in X$, então $p\neq 1$, logo existe $q\in\mathbb{N}$ tal que $s(q)=p$. Mas $p=s(q)\not\in X\implies q\not\in X\implies q\in\complement X\implies s(q)=p\in s(\complement X)$. Absurdo, logo $\complement X=\emptyset$ e, portanto, $X=\mathbb{N}$. $\blacksquare$ 