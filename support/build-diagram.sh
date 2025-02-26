#/usr/bin/env bash

target="${1}"
source="${2}"

latex () {
cat <<EOF
\documentclass[varwidth,multi=page,12pt]{standalone}
\usepackage{xcolor}
\usepackage{tikz-cd}
\usepackage{amssymb}
\usepackage{amsmath}
\usepackage{amsopn}
\usetikzlibrary{calc}
\usetikzlibrary{decorations.pathmorphing}
\definecolor{eee}{HTML}{EEEEEE}
\tikzset{curve/.style={settings={#1},to path={(\tikztostart)
    .. controls (\$(\tikztostart)!\pv{pos}!(\tikztotarget)!\pv{height}!270:(\tikztotarget)$)
    and (\$(\tikztostart)!1-\pv{pos}!(\tikztotarget)!\pv{height}!270:(\tikztotarget)$)
    .. (\tikztotarget)\tikztonodes}},
    settings/.code={\tikzset{quiver/.cd,#1}
        \def\pv##1{\pgfkeysvalueof{/tikz/quiver/##1}}},
    quiver/.cd,pos/.initial=0.35,height/.initial=0}

\tikzset{tail reversed/.code={\pgfsetarrowsstart{tikzcd to}}}
\tikzset{2tail/.code={\pgfsetarrowsstart{Implies[reversed]}}}
\tikzset{2tail reversed/.code={\pgfsetarrowsstart{Implies}}}
\tikzset{no body/.style={/tikz/dash pattern=on 0 off 1mm}}
\begin{document}
\begin{page}
EOF

cat ${source}

cat <<EOF
\end{page}
\end{document}
EOF
}

latex \
  | rubber-pipe --pdf 2>/dev/null \
  | pdftocairo -svg - - \
  > ${target}