---
layout: post
title:  "Como os telescópios funcionam"
date:   2025-08-25 20:31:56 -0300
render_with_liquid: false
---

Em algum lugar muito distante, uma pequena parcela da luz emitida ou refletida por algum objeto celeste inicia a sua viagem com destino à Terra. Após percorrer distâncias inimagináveis, uma parcela dessa luz entra pela abertura de um telescópio, é refletida por espelhos e/ou desviada por lentes na medida certa para forma uma imagem ampliada do objeto, que pode então ser visualizada por nós ao colocarmos o olho na ocular do telescópio.

Este artigo tem como objetivo apresentar os princípios de funcionamento dos telescópio e a dedução de algumas de suas relações básicas. Vamos considerar uma configuração simples, de um telescópio formado por duas lentes: a objetiva, que focaliza a luz, e a ocular, que realiza a ampliação da imagem.

# Querida, encolhi as crianças

Vamos começar analisando o efeito da objetiva. A luz do objeto distante (em azul) é focalizada pela objetiva, formando uma imagem (em vermelho). Sendo $h_1$ e $h_2$ as alturas do objeto distante e de sua imagem, $d_1$ e $d_2$ suas respectivas distâncias até a objetiva e $f_{ob}$ a distância focal da objetiva, obtemos as relações a seguir: 

```tikz
\usetikzlibrary{calc}
\usetikzlibrary{intersections}

\definecolor{myblue}{rgb}{0, 0.4470, 0.7410}
\definecolor{myorange}{rgb}{0.8500, 0.3250, 0.0980}
%\definecolor{color2}{rgb}{0.4940, 0.1840, 0.5560}
\definecolor{myyellow}{rgb}{0.9290, 0.6940, 0.1250}
\definecolor{mylightblue}{rgb}{0.3010, 0.7450, 0.9330}

\tikzstyle{arrow} = [->, > = stealth, line width = 1 mm]
\tikzstyle{ray} = [thick, color = myyellow]

\begin{document}
	\begin{tikzpicture}
		\pgfmathsetmacro{\f}{3}
		\pgfmathsetmacro{\hobject}{3}
		\pgfmathsetmacro{\dobject}{10}
		\pgfmathsetmacro{\xmin}{-11}
		\pgfmathsetmacro{\xmax}{11}
		\pgfmathsetmacro{\lensdiameter}{8}
		\pgfmathsetmacro{\lenswidth}{.8}
		
		\clip (\xmin,-5) rectangle (\xmax, 5);
		%\draw (\xmin,-10) grid (\xmax, 10);

		\coordinate(origin) at (0,0);
		
		\coordinate(objectbottom) at (-\dobject,0);
		\coordinate(objecttop) at (-\dobject,\hobject);

		\coordinate(f1) at (-\f,0);
		\coordinate(f2) at (\f,0);

		% object
		\draw[arrow, color = myblue] (objectbottom) -- (objecttop);

		% intersections of rays and lens
		\coordinate(A) at (objecttop-|origin);
		\coordinate(B) at (0,{-\hobject/(\dobject-\f)*\f});
		
		% ray 1
		\draw[ray] (objecttop) -- (A);
		\draw[ray, name path=ray 1] (A) -- ($(A)!100cm!(f2)$);

		% ray 2
		% \draw[ray] (objecttop) -- (B);
		% \draw[ray, name path=ray 2]  (B) -- ++(0:100cm);

		% ray 3
		\draw[ray] (objecttop) -- (origin);
		\draw[ray, name path=ray 3] (origin) -- ($(origin)!-100cm!(objecttop)$);

		% x axis
		\draw (\xmin,0) -- (\xmax,0);
		
		% image
		\path[name intersections={of=ray 1 and ray 3, by=imagetop}];
		\coordinate(imagebottom) at (imagetop|-origin);
		\draw[arrow, color = myorange] (imagebottom) -- (imagetop);

		% lens
		\pgfmathsetmacro{\lensarcangle}{2*atan(\lenswidth/\lensdiameter)}
		\pgfmathsetmacro{\lensarcradius}{\lensdiameter/2/sin(\lensarcangle)}

		\draw[dashed] (0,{-\lensdiameter/2}) -- ++(0,\lensdiameter);

		\draw[fill=mylightblue, fill opacity=.5] (0,{-\lensdiameter/2}) arc (-\lensarcangle:\lensarcangle:\lensarcradius) arc (180-\lensarcangle:180+\lensarcangle:\lensarcradius);
		
		\newcommand{\dimline}[5]{%from, to, shift, label
		  \draw[|<->|, thick] ($#1 + #3$) -- node[#5]{#4} ($#2 + #3$);
		  \draw[dashed] ($#1$) -- ($#1 + #3$);
		  \draw[dashed] ($#2$) -- ($#2 + #3$);
		}

		\dimline{(origin)}{(-\f,0)}{(0,-2cm)}{$f_{ob}$}{below};
		\dimline{(origin)}{(\f,0)}{(0,-2cm)}{$f_{ob}$}{below};
		\dimline{(origin)}{(objectbottom)}{(0,-3cm)}{$d_{1}$}{below};
		\dimline{(origin)}{(imagebottom)}{(0,-3cm)}{$d_{2}$}{below};
		\dimline{(objectbottom)}{(objecttop)}{(-.5cm,0)}{$h_{1}$}{left};
		\dimline{(imagebottom)}{(imagetop)}{(.5cm,0)}{$h_{2}$}{right};

		
	
	\end{tikzpicture}
\end{document}
```
$$
\begin{align} \\
\frac{h_{1}}{d_{1}}&=\frac{h_{2}}{d_{2}}&\implies&& \frac{h_{1}}{h_{2}}&=\frac{d_{1}}{d_{2}}\tag{1}\\ \\
\frac{h_{1}}{f_{ob}}&=\frac{h_{2}}{d_{2}-f_{ob}}&\implies&&\frac{h_{1}}{h_{2}}&=\frac{f_{ob}}{d_{2}-f_{oc}}\tag{2}\\ \\
%\frac{h_{1}}{d_{1}-f_{ob}}&=\frac{h_{2}}{f_{ob}}&\implies&& \frac{h_{1}}{h_{2}}&=\frac{d_{1}-f_{ob}}{f_{ob}}
\end{align}
$$

Igualando $(1)$ e $(2)$:

$$
\begin{equation}
\frac{f_{ob}}{d_{2}-f_{ob}}=\frac{d_{1}}{d_{2}}\implies \frac{1}{d_{1}}=\frac{d_{2}-f_{ob}}{d_{2}\cdot f_{ob}}\implies \frac{1}{d_{1}}=\frac{1}{f_{ob}}-\frac{1}{d_{2}}\implies \boxed{d_{2}=\frac{1}{\frac{1}{f_{ob}}-\frac{1}{d_{1}}}}\tag{3}
\end{equation}
$$
Substituindo $(3)$ em $(1)$:

$$
\begin{equation}
\frac{h_{1}}{h_{2}}=\frac{d_{1}}{d_{2}}\implies h_{2}=d_{2}\cdot \frac{h_{1}}{d_{1}}=\frac{1}{\frac{1}{f_{ob}}-\frac{1}{d_{1}}}\cdot \frac{h_{1}}{d_{1}}\implies\boxed{h_{2}=\frac{h_{1}}{\frac{d_{1}}{f_{ob}}-1}}\tag{4}
\end{equation}
$$
Vamos considerar, por exemplo, Saturno. Temos $h_{1}=120\ 500~\mathrm{km}$ (diâmetro de Saturno) e $d_{1}=1\ 427\ 000\ 000~\mathrm{km}$ (distância média entre Saturno e a Terra). Considerando uma objetiva com distância focal $f_{ob}=1~\mathrm{m}$:
$$
\begin{align}
d_{2}&\approx 1~\mathrm{m}\\ \\
h_{2}&\approx 84{,}44~\mathrm{\upmu m}
\end{align}
$$
Ou seja, a imagem de Saturno é formada aproximadamente no foco da objetiva, com um diâmetro próximo ao de um fio de cabelo humano. O próximo passo é ampliar esta imagem (literalmente) microscópica.
# Ao infinito e além

Precisamos formar uma imagem ampliada a partir da imagem microscópica presente no foco da objetiva. Além disso, é desejável que esta imagem ampliada esteja distante, para tornar a observação mais confortável. Conseguimos fazer isso com uma segunda lente convergente, chamada de *ocular*. 

A ocular é posicionada de forma que a imagem microscópica fique a uma distância da ocular menor do que a sua distância focal. Com isso, é formada uma imagem virtual ampliada e mais distante. No diagrama abaixo, é utilizada a notação $d_{2}^\prime$ para representar a distância entre a imagem microscópica e a objetiva, para diferenciar de $d_{2}$, que é a distância entre esta mesma imagem e a ocular.
```tikz
\usetikzlibrary{calc}
\usetikzlibrary{intersections}

\definecolor{myblue}{rgb}{0, 0.4470, 0.7410}
\definecolor{myorange}{rgb}{0.8500, 0.3250, 0.0980}
\definecolor{mypurple}{rgb}{0.4940, 0.1840, 0.5560}
\definecolor{myyellow}{rgb}{0.9290, 0.6940, 0.1250}
\definecolor{mylightblue}{rgb}{0.3010, 0.7450, 0.9330}

\tikzstyle{arrow} = [->, > = stealth, line width = 1 mm]
\tikzstyle{ray} = [thick, color = myyellow]

\begin{document}
	\begin{tikzpicture}
		\pgfmathsetmacro{\f}{2.8}
		\pgfmathsetmacro{\hobject}{-3/(10/3-1)}
		\pgfmathsetmacro{\dobject}{2}
		\pgfmathsetmacro{\xmin}{-11}
		\pgfmathsetmacro{\xmax}{5}
		\pgfmathsetmacro{\lensdiameter}{5}
		\pgfmathsetmacro{\lenswidth}{.6}

		\clip(\xmin,-5) rectangle (\xmax,5);

		\coordinate(origin) at (0,0);
		
		\coordinate(objectbottom) at (-\dobject,0);
		\coordinate(objecttop) at (-\dobject,\hobject);

		\coordinate(f1) at (-\f,0);
		\coordinate(f2) at (\f,0);

		% object
		\draw[arrow, color = myorange] (objectbottom) -- (objecttop);

		% intersections of rays and lens
		\coordinate(A) at (objecttop-|origin);
		\coordinate(B) at (0,{-\hobject/(\dobject-\f)*\f});
		
		% ray 1
		\draw[ray] (objecttop) -- (A);
		\draw[ray] (A) -- ($(A)!100cm!(f2)$);
		\draw[ray, dashed, name path=ray 1] (A) -- ($(A)!-100cm!(f2)$);

		% ray 2
		%\draw[ray] (objecttop) -- (B);
		%\draw[ray]  (B) -- ++(0:100cm);
		%\draw[ray, dashed, name path=ray 2]  (B) -- ++(0:-100cm);
		%\draw[ray, dashed, color=myblue]  (objecttop) -- (-\f,0);

		% ray 3
		\draw[ray] (objecttop) -- (origin);
		\draw[ray] (origin) -- ($(origin)!-100cm!(objecttop)$);
		\draw[ray, dashed, name path=ray 3] (origin) -- ($(origin)!100cm!(objecttop)$);
		
		% x axis
		\draw (\xmin,0) -- (\xmax,0);
		
		% image
		\path[name intersections={of=ray 1 and ray 3, by=imagetop}];
		\coordinate(imagebottom) at (imagetop|-origin);
		\draw[arrow, color = mypurple] (imagebottom) -- (imagetop);

		% lens
		\pgfmathsetmacro{\lensarcangle}{2*atan(\lenswidth/\lensdiameter)}
		\pgfmathsetmacro{\lensarcradius}{\lensdiameter/2/sin(\lensarcangle)}

		\draw[dashed] (0,{-\lensdiameter/2}) -- ++(0,\lensdiameter);

		\draw[fill=mylightblue, fill opacity=.5] (0,{-\lensdiameter/2}) arc (-\lensarcangle:\lensarcangle:\lensarcradius) arc (180-\lensarcangle:180+\lensarcangle:\lensarcradius);
		
		\newcommand{\dimline}[5]{%from, to, shift, label
		  \draw[|<->|, thick] ($#1 + #3$) -- node[#5]{#4} ($#2 + #3$);
		  \draw[dashed] ($#1$) -- ($#1 + #3$);
		  \draw[dashed] ($#2$) -- ($#2 + #3$);
		}

		\dimline{(origin)}{(-\f,0)}{(0,1.5cm)}{$f_{oc}$}{above};
		\dimline{(origin)}{(\f,0)}{(0,1.5cm)}{$f_{oc}$}{above};
		\dimline{(origin)}{(objectbottom)}{(0,.5cm)}{$d_{2}^\prime$}{above};
		\dimline{(origin)}{(imagebottom)}{(0,2.5cm)}{$d_{3}$}{above};
		\dimline{(objectbottom)}{(objecttop)}{(-.5cm,0)}{$h_{2}$}{left};
		\dimline{(imagebottom)}{(imagetop)}{(-.5cm,0)}{$h_{3}$}{left};

	\end{tikzpicture}
\end{document}
```
$$
\begin{align}
\frac{h_{2}}{d_{2}^\prime}&=\frac{h_{3}}{d_{3}}&\implies&& \frac{h_{2}}{h_{3}}&=\frac{d_{2}^\prime}{d_{3}}\tag{5}\\ \\
\frac{h_{2}}{f_{oc}}&=\frac{h_{3}}{d_{3}+f_{oc}}&\implies&& \frac{h_{2}}{h_{3}}&=\frac{f_{oc}}{d_{3}+f_{oc}}\tag{6}
\end{align}
$$
Igualando $(5)$ e $(6)$:
$$
\begin{equation}
\frac{d_{2}^\prime}{d_{3}}=\frac{f_{oc}}{d_{3}+f_{oc}}\implies \frac{d_{3}+f_{oc}}{d_{3}\cdot f_{oc}}=\frac{1}{d_{2}^\prime}\implies \frac{1}{f_{oc}}+\frac{1}{d_{3}}=\frac{1}{d_{2}^\prime}\implies \boxed{d_{3}=\frac{1}{\frac{1}{d_{2}^\prime}-\frac{1}{f_{oc}}}}\tag{7}
\end{equation}
$$
Substituindo $(7)$ em $(5)$:
$$
\frac{h_{2}}{h_{3}}=\frac{d_{2}^\prime}{d_{3}}\implies h_{3}=d_{3}\cdot \frac{h_{2}}{d_{2}^\prime}=\frac{1}{\frac{1}{d_{2}^\prime}-\frac{1}{f_{oc}}}\cdot \frac{h_{2}}{d_{2}^\prime}\implies\boxed{h_{3}=\frac{h_{2}}{1-\frac{d_{2}^\prime}{f_{oc}}}}\tag{8}
$$
Agora vamos fazer algumas aproximações razoáveis a fim de obter a ampliação total do nosso telescópio. Primeiramente, os objetos que observamos estão, pelo menos, a centenas de milhares de quilômetros de distância (a Lua, por exemplo, está a uma distância média de $384\ 400~ \mathrm{km}$ da Terra). Portanto, é razoável considerar $d_{1}\gg f_{ob}$. Além disso, desejamos que a imagem virtual formada pela objetiva esteja distante, para facilitar a observação. De maneira talvez um tanto poética, queremos que a imagem se forme no *infinito*. Na prática, é isto que buscamos quando movimentamos a ocular até obter uma imagem nítida com o olho relaxado. Logo podemos supor $d_3\gg f_{oc}$.

Vamos às repercussões dessas aproximações. Pela equação $(3)$, considerando $d_{1}\gg f_{ob}$:
$$
d_{2}=\frac{1}{\frac{1}{f_{ob}}-\frac{1}{d_{1}}}=\frac{f_{ob}\cdot d_{1}}{d_{1}-f_{ob}}\approx \frac{f_{ob}\cdot d_{1}}{d_{1}}=f_{ob}\implies d_{2}\approx f_{ob}
$$
De forma análoga, pela equação $(7)$, considerando $d_{3}\gg f_{oc}$:
$$
d_{3}=\frac{1}{\frac{1}{d_{2}^\prime}-\frac{1}{f_{oc}}}\implies \frac{1}{d_{2}^\prime}=\frac{1}{d_{3}}+\frac{1}{f_{oc}}\implies d_{2}^\prime=\frac{f_{oc}\cdot d_{3}}{d_{3}+{f_{oc}}}\approx \frac{f_{oc}\cdot d_{3}}{d_{3}}=f_{oc}\implies d_{2}^\prime\approx f_{oc}
$$
Em resumo, o foco da objetiva coincide com o foco da ocular e a imagem formada pela objetiva está localizada neste ponto comum, em ambos os focos das lentes.

Agora, a etapa final para obtermos a ampliação, ou magnificação, de nosso telescópio, isto é, o quão maior nos parece a imagem observada por meio do telescópio em comparação à observação a olho nu.

A imagem de um objeto projetada em nossa retina tem um tamanho proporcional ao ângulo visual do objeto. Sendo assim, para obtermos a ampliação do telescópio, devemos comparar o ângulo visual $\alpha_{eye}$ ao observar o objeto a olho nu com o ângulo visual $\alpha_{tele}$ ao observar o objeto utilizando o telescópio. Considerando ângulos visuais pequenos, podemos usar a aproximação $\tan\alpha\approx\alpha$. 
$$
\begin{align}
\alpha_{eye}&\approx\tan(\alpha_{eye})=\frac{h_{1}}{d_{1}}=\frac{h_{2}}{d_{2}}\approx \frac{h_{2}}{f_{ob}}\\ \\
\alpha_{tele}&\approx\tan(\alpha_{tele})=\frac{h_{3}}{d_{3}}=\frac{h_{2}}{d_{2}^\prime}\approx \frac{h_{2}}{f_{oc}} 
\end{align}
$$

A ampliação, ou magnificação, representada por $M$, é dada pela razão dos ângulos visuais:
$$
M=\frac{\alpha_{tele}}{\alpha_{eye}}\approx\frac{\tan(\alpha_{tele})}{\tan(\alpha_{eye})}\approx \frac{\frac{h_{2}}{f_{oc}}}{\frac{h_{2}}{f_{ob}}}=\frac{h_{2}}{f_{oc}}\cdot \frac{f_{ob}}{h_{2}}\implies \boxed{M\approx\frac{f_{ob}}{f_{oc}}}
$$
Por exemplo, considerando um telescópio com distância focal de $1000~\mathrm{mm}$ e utilizando uma ocular de $10~\mathrm{mm}$, será obtida uma ampliação de $1000/10=100$ vezes. 

Então basta construirmos telescópios com distâncias focais arbitrariamente grandes e utilizarmos oculares com distâncias focais arbitrariamente pequenas para conseguirmos ampliações tão grandes quanto desejarmos, certo? Infelizmente, não existe almoço grátis. A turbulência atmosférica, a qualidade das lentes e a própria natureza ondulatória da luz (neste caso, mais especificamente, o fenômeno de difração) são fatores que limitam a resolução angular máxima de um telescópio, consequentemente degradando a resolução da imagem obtida conforme são utilizadas ampliações mais elevadas.
# Rápido e devagar

Muitas vezes os telescópios não são utilizados para observações diretas, mas sim para *astrofotografia*. Neste caso, uma câmera é colocada na posição da ocular. A câmera é apenas um sensor, sem lentes, que converte a imagem projetada nele em sinais elétricos, produzindo a imagem digital. Nesta situação, a lente é o próprio telescópio (mais especificamente, a objetiva), que focaliza a imagem no sensor.

A não ser que estejamos fotografando o Sol (não faça isso em casa sem filtros adequados) ou a Lua, estamos falando de objetos com pouca luz. Neste contexto, as imagens são obtidas por meio de *longa exposição*: o sensor captura a luz recebida durante um determinado intervalo de tempo e produz a imagem final como um *somatório* de toda a luz recebida neste intervalo. Quanto maior o tempo de exposição, menor o nível de ruído na imagem final.

Fixado um determinado nível de ruído, o tempo de exposição será inversamente proporcional à concentração de potência luminosa que chega ao sensor. Telescópios que produzem uma maior concentração de potência no sensor irão necessitar tempos de exposição menores. Diz-se que esses telescópios são *rápidos*. De maneira análoga, telescópios que produzem concentrações menores, necessitando de tempos de exposição mais longos, são ditos *lentos*.

Que características construtivas do telescópio determinam se ele é rápido ou lento? Vamos aos cálculos.

No Sistema Internacional de Unidades, o *fluxo luminoso*, uma medida da potência percebida de luz visível emitida por uma fonte, é medido em *lúmens* (lm). A grosso modo, o fluxo luminoso está relacionado à *quantidade* de luz visível (é como uma medida da quantidade de raios de luz). Já o fluxo luminoso por unidade de área, ou *iluminância*, é medido em *lux* (lx), que é equivalente a um lúmen por metro quadrado. Portanto, a grosso modo, a iluminância é uma medida da *concentração* de luz visível (é como uma medida da quantidade de raios de luz por unidade de área).

A luz emitida pelos objetos que observamos pelo telescópio chega a nós sob a forma de raios praticamente paralelos e distribuídos homogeneamente, devido à grande distância, produzindo, portanto, uma iluminância (concentração de raios de luz) constante. Seja $E_{V}$ a iluminância referente ao objeto observado (o subscrito $V$ reforça que considera-se apenas a luz *visível*) . O fluxo luminoso (quantidade de luz) captado pelo telescópio depende da área da objetiva, sendo dado por:
$$
\Phi_{V}=E_{V} \cdot \frac{\pi D^{2}}{4} 
$$
em que $D$ é o diâmetro da objetiva.

Pela equação $(1)$ e pela aproximação $d_{2}\approx f_{ob}$:
$$
\frac{h_{1}}{h_{2}}=\frac{d_{1}}{d_{2}}\approx \frac{d_{1}}{f_{ob}}
$$
Ou seja, as dimensões do objeto são reduzidas por um fator $d_{1}/f_{ob}$. Sendo assim, a área do objeto é reduzida pelo quadrado deste fator, isto é:
$$
\frac{S_{1}}{S_{2}}=\frac{d_{1}^2}{f_{ob}^2}\implies S_{2}=S_{1}\cdot \frac{f_{ob}^2}{d_{1}^2}
$$
Note que estamos considerando aqui a área projetada do objeto, isto é, a área obtida ao projetá-lo ortogonalmente em um plano perpendicular à direção observada, e não a sua área superficial total. Além disso, os objetos celestes geralmente subentendem ângulos pequenos no céu, de forma que a sua área projetada ortogonalmente no plano perpendicular à direção observada é aproximadamente igual à sua área projetada *radialmente* em uma esfera de raio $d_{1}$ centrada na Terra. Isso é consequência de que $\sin \theta\approx \theta$ para $\theta$ pequeno em radianos, com a projeção ortogonal estando relacionada a $\sin\theta$ e a projeção radial a $\theta$. Sendo assim, $S_{1}/d_{1}^2$ é aproximadamente o ângulo sólido $\Omega$ subentendido pelo objeto. Logo:
$$
S_{2}=\Omega \cdot f_{ob}^2
$$
O fluxo luminoso captado pelo telescópio será concentrado em uma área $S_{2}$ no sensor da câmera, resultando em uma iluminância dada por:
$$
E_{V}^{sens}=\frac{\Phi_{V}}{S_{2}}=\frac{E_{V}\cdot \frac{\pi D^2}{4}}{\Omega\cdot f_{ob}^2}=\frac{E_{V}\cdot\pi}{4\cdot \Omega}\cdot \left(\frac{D}{f_{ob}}\right)^2
$$
Note que o primeiro termo, $\frac{E_{V}\cdot\pi}{4\cdot \Omega}$, independe do telescópio, dependendo apenas de características relativas ao objeto celeste observado. O ângulo sólido $\Omega$  subentendido pelo objeto é determinado por suas dimensões e pela sua distância em relação à Terra. Já o valor de $E_V$ está intimamente relacionado à *magnitude aparente* do objeto, medida em escala logarítmica, que será detalhada na seção seguinte. Sendo assim, a rapidez ou vagareza de um telescópio está relacionada ao quadrado da razão entre sua abertura $D$ e sua distância focal $f_{ob}$. Portanto:
$$
\boxed{E_{V}^{sens}\propto\left( \frac{D}{f_{ob}} \right)^2}
$$
A relação é intuitiva: enquanto $D^2$ é diretamente proporcional à quantidade de luz captada pelo telescópio, o termo $f_{ob}^2$ é diretamente proporcional à área da imagem do objeto projetada no sensor. Telescópios que captam mais luz (maior $D^2$) e que produzem imagens menores (menor $f_{ob}^2$), i.e., concentram mais a luz recebida, produzirão iluminâncias maiores no sensor, exigindo tempos de exposição menores.

Uma última observação deve ser feita sobre telescópios que possuem alguma obstrução que reduza a sua área útil de abertura, como estruturas comumente utilizadas para o posicionamento de espelhos em telescópios reflexivos. Neste caso, a iluminância $E_{V}^{sens}$ no sensor deve ser corrigida pelo fator de obstrução, i.e., multiplicada pela razão entre a área útil de abertura e a área caso não houvesse obstrução ($\pi D^2/4$).
## Magnitude aparente

A magnitude aparente pode ser calculada para diversas bandas específicas do espectro eletromagnético, tendo como forma geral:
$$
m_{x}=-2{,}5\log_{10}\left( \frac{E_{x}}{E_{x0}} \right)
$$
em que $E_x$ é a iluminância do objeto na banda espectral $x$ e $E_{x0}$ é a iluminância de referência para esta banda (que produz $m_x=0$). No caso da banda visível ([Fonte](https://stjarnhimlen.se/comp/radfaq.html#7)):
$$
m_{V}=-2{,}5\log_{10}\left( \frac{E_{V}}{E_{V0}} \right),~~~~E_{V0}=2{,}54~\mathrm{\upmu lx}
$$
Logo:
$$
E_{V}=2{,}54\cdot 10^{-6}\cdot 10^{-m_{V}/2{,}5}=2{,}54\cdot 10^{-(0{,}4\cdot m_{V}+6)}
$$
As magnitudes aparentes geralmente são informadas considerando uma observação fora da atmosfera terrestre. É necessário compensar o valor de magnitude, considerando a *extinção* da luz (absorção e dispersão) que ocorre devido à presença da atmosfera. Antes de prosseguir, vamos a algumas definições.

O *zênite* é o ponto no céu diretamente *acima* de uma localidade em particular. É o ponto *mais alto* do céu. O *ângulo de zênite* de um objeto celeste é o ângulo entre o objeto e o zênite. Uma *massa de ar* é uma medida da quantidade de ar ao longo da linha de visão ao observar um objeto celeste a partir de um ponto dentro da atmosfera da Terra. Geralmente esta medida é dada relativamente à massa de ar do zênite, i.e., considera-se que a luz de um objeto celeste localizado no zênite percorre $1$ massa de ar até chegar a um observador no nível do mar. Evidentemente, a quantidade de massas de ar varia de acordo com a altitude do local observado, podendo ser, inclusive, menor do que $1$ em altitudes mais elevadas.

Temos que $1$ massa de ar limpo transmite aproximadamente $82\%$ da luz visível ([Fonte](https://stjarnhimlen.se/comp/radfaq.html#7)). Isso corresponde a uma variação de magnitude de $-2{,}5\log_{10}(0{,}82)\approx 0{,}2$. Portanto a magnitude aparente dentro da atmosfera terrestre, considerando uma atmosfera limpa e um observador ao nível do mar, é dada por:
$$
m_{V}=m_{V}^{out}+0{,}2\cdot X
$$
em que $m_{V}^{out}$ é a magnitude aparente no espectro visível ao observar o objeto fora da atmosfera terrestre e $X$ a quantidade de massas de ar na linha de visão do observador.

Para objetos com ângulo de zênite pequeno ou moderado (até cerca de 60°), uma boa aproximação para a quantidade de massas de ar é obtida considerando uma atmosfera homogênea plana (i.e., com densidade constante e desconsiderando a curvatura da Terra). Nessas condições, considerando um observador ao nível do mar, a massa de ar relativa para um objeto com ângulo de zênite $z$ pode ser aproximada por:

```tikz
\usetikzlibrary{calc}
\begin{document}
	\begin{tikzpicture}
		\newcommand{\dimline}[5]{%from, to, shift, label, position
		  \coordinate(delta) at ([rotate=-90]$(0,0)!#3!($#2 - #1$)$);
		  \draw[|<->|, thick] ($#1+(delta)$) -- node[#5]{#4} ($#2+(delta)$);
		  \draw[dashed] ($#1$) -- ($#1+(delta)$);
		  \draw[dashed] ($#2$) -- ($#2+(delta)$);
		}

		\pgfmathsetmacro{\ymax}{5};
		\pgfmathsetmacro{\yatm}{2};
		\pgfmathsetmacro{\xmax}{6};
		\pgfmathsetmacro{\dobject}{5.5}
		\pgfmathsetmacro{\z}{60};
		\pgfmathsetmacro{\X}{\yatm/cos(\z)};

		\fill[color=cyan, opacity=0.4] (-\xmax,0) rectangle (\xmax,\yatm);

		\coordinate(object) at (90+\z:\dobject);
		\coordinate(origin) at (0,0);
		\coordinate(zenith) at (0,\ymax);
		\coordinate(rayatm) at (90+\z:\X);

		\draw (-\xmax,0) -- (\xmax,0);
		\draw (-\xmax,\yatm) -- (\xmax,\yatm);
		\draw[fill] (object) circle (.1);
		\draw (object) -- (origin);

		\draw[dashed] (origin) -- (zenith);

		\draw (origin) ++(0,1) arc (90:90+\z:1) node[midway, above]{$z$};

		\dimline{(origin)}{(rayatm)}{-.25cm}{$X$}{below left};
		\dimline{(origin)}{(0,\yatm)}{.25cm}{$1$}{right};

	\end{tikzpicture}
\end{document}
```
$$
\boxed{X=\frac{1}{\cos z}}
$$
Levando em conta a curvatura da Terra, uma melhor aproximação pode ser obtida ([Fonte](https://en.wikipedia.org/wiki/Air_mass_(astronomy))):

```tikz
\usetikzlibrary{calc}
\usetikzlibrary{intersections}
\begin{document}
	\begin{tikzpicture}
		\newcommand{\dimline}[5]{%from, to, shift, label, position
		  \coordinate(delta) at ([rotate=-90]$(0,0)!#3!($#2 - #1$)$);
		  \draw[|<->|, thick] ($#1+(delta)$) -- node[#5]{#4} ($#2+(delta)$);
		  \draw[dashed] ($#1$) -- ($#1+(delta)$);
		  \draw[dashed] ($#2$) -- ($#2+(delta)$);
		}
		
		\pgfmathsetmacro{\ymax}{5};
		\pgfmathsetmacro{\yatm}{2};
		\pgfmathsetmacro{\xmax}{10};
		\pgfmathsetmacro{\dobject}{5.5}
		\pgfmathsetmacro{\z}{60};
		\pgfmathsetmacro{\R}{3};
		\pgfmathsetmacro{\X}{sqrt((\R*cos(\z))^2 + 2*\R*\yatm + \yatm^2) - \R * cos(\z)};
		
		\clip (-\xmax,-\R-1) rectangle (\xmax,\ymax);

		\coordinate(object) at (90+\z:\dobject);
		\coordinate(origin) at (0,0);
		\coordinate(zenith) at (0,\ymax);
		\coordinate(center) at (0,-\R);
		\coordinate(rayatm) at (90+\z:\X);
		
		\draw[name path=earth] (0,-\R) circle (\R);
		\draw[name path=atm] (0,-\R) circle (\R+\yatm);
		\draw[fill] (object) circle (.1);
		\draw[name path=ray] (object) -- (origin);
		\fill[color=cyan, opacity=0.4, even odd rule]  (0,-\R) circle (\R)
							  (0,-\R) circle (\R+\yatm);

		\draw[dashed] (origin) -- (zenith);
					
		\draw (origin) ++(0,.5) arc (90:90+\z:.5) node[midway, above]{$z$};

		\draw (center) -- (rayatm);
		\dimline{(center)}{(rayatm)}{-.5cm}{$r+1$}{below left};

		\draw[dashed] (center) -- (origin);
		\dimline{(center)}{(origin)}{.5cm}{$r$}{right};

		\draw (rayatm) -- (rayatm-|origin);
		\dimline{(rayatm)}{(rayatm-|origin)}{-.5cm}{$X\sin z$}{above};

		\dimline{(origin)}{(rayatm)}{0cm}{$X$}{below left};
		\dimline{(origin)}{(0,\yatm)}{2cm}{$1$}{right};
		\dimline{(origin)}{(rayatm-|origin)}{.5cm}{$X\cos z$}{right};	

	\end{tikzpicture}
\end{document}
```
$$
\begin{aligned}
(X\sin z)^2+(X\cos z +r)^2=(r+1)^2\\ \\
X^2\sin^{2}z+X^{2}\cos ^{2}z+2\cdot X\cos z\cdot r+r^{2}=r^{2}+2r+1\\ \\
X^{2}(\sin ^{2}z+\cos ^{2}z)+2\cdot X\cdot r\cos z=2r+1\\ \\
X ^{2}+2\cdot X\cdot r\cos z+r^{2}\cos ^{2}z=r^{2}\cos ^{2}z+2r+1\\ \\
(X+r\cos z)^{2}=r^{2}\cos ^{2}z+2r+1\\ \\
X+r\cos z=\sqrt{ r^{2}\cos ^{2} z +2r+1}\\ \\
\boxed{X=\sqrt{ r^{2}\cos ^{2}z+2r+1 }-r\cos z}
\end{aligned}
$$
em que $r=R_E/y_{atm}$ é a razão entre o raio da Terra e a altura da atmosfera ($r\approx 6371~\mathrm{km}/9~\mathrm{km}\approx 708$).