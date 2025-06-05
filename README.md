# Relatorio Mensal
Athos Petri Damiani
2025-06-05

## Introducao

Este documento contem:

-   Demonstracao de markdown
-   tabelas, graficos, e textos dinamicos
-   chunks de codigo misturados com blocos de texto
-   Demonstracao de que o Quarto pode ser usado tanto como notebook
    quanto para gerar documentos apresentaveis

## Exemplo de variaveis de ambiente e Sys.getenv()

``` r
Sys.getenv("TESTE", "nao encontrou o env TESTE")
```

    [1] "Encontrou o ENV TESTE configurado no Settings do Github Actions do Repositorio"

ola mundo

## Dados da analise

``` r
# mtcars_from_db <- sdf_sql(sc, "SELECT * FROM databricks_asn.default.mtcars_id")
# mtcars_from_db <- tbl(sc, "mtcars_from_local")
mtcars_from_db <- mtcars
mtcars_from_db |> head() |> kable()
```

<table style="width:100%;">
<colgroup>
<col style="width: 26%" />
<col style="width: 7%" />
<col style="width: 5%" />
<col style="width: 7%" />
<col style="width: 5%" />
<col style="width: 7%" />
<col style="width: 8%" />
<col style="width: 8%" />
<col style="width: 4%" />
<col style="width: 4%" />
<col style="width: 7%" />
<col style="width: 7%" />
</colgroup>
<thead>
<tr>
<th style="text-align: left;"></th>
<th style="text-align: right;">mpg</th>
<th style="text-align: right;">cyl</th>
<th style="text-align: right;">disp</th>
<th style="text-align: right;">hp</th>
<th style="text-align: right;">drat</th>
<th style="text-align: right;">wt</th>
<th style="text-align: right;">qsec</th>
<th style="text-align: right;">vs</th>
<th style="text-align: right;">am</th>
<th style="text-align: right;">gear</th>
<th style="text-align: right;">carb</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align: left;">Mazda RX4</td>
<td style="text-align: right;">21.0</td>
<td style="text-align: right;">6</td>
<td style="text-align: right;">160</td>
<td style="text-align: right;">110</td>
<td style="text-align: right;">3.90</td>
<td style="text-align: right;">2.620</td>
<td style="text-align: right;">16.46</td>
<td style="text-align: right;">0</td>
<td style="text-align: right;">1</td>
<td style="text-align: right;">4</td>
<td style="text-align: right;">4</td>
</tr>
<tr>
<td style="text-align: left;">Mazda RX4 Wag</td>
<td style="text-align: right;">21.0</td>
<td style="text-align: right;">6</td>
<td style="text-align: right;">160</td>
<td style="text-align: right;">110</td>
<td style="text-align: right;">3.90</td>
<td style="text-align: right;">2.875</td>
<td style="text-align: right;">17.02</td>
<td style="text-align: right;">0</td>
<td style="text-align: right;">1</td>
<td style="text-align: right;">4</td>
<td style="text-align: right;">4</td>
</tr>
<tr>
<td style="text-align: left;">Datsun 710</td>
<td style="text-align: right;">22.8</td>
<td style="text-align: right;">4</td>
<td style="text-align: right;">108</td>
<td style="text-align: right;">93</td>
<td style="text-align: right;">3.85</td>
<td style="text-align: right;">2.320</td>
<td style="text-align: right;">18.61</td>
<td style="text-align: right;">1</td>
<td style="text-align: right;">1</td>
<td style="text-align: right;">4</td>
<td style="text-align: right;">1</td>
</tr>
<tr>
<td style="text-align: left;">Hornet 4 Drive</td>
<td style="text-align: right;">21.4</td>
<td style="text-align: right;">6</td>
<td style="text-align: right;">258</td>
<td style="text-align: right;">110</td>
<td style="text-align: right;">3.08</td>
<td style="text-align: right;">3.215</td>
<td style="text-align: right;">19.44</td>
<td style="text-align: right;">1</td>
<td style="text-align: right;">0</td>
<td style="text-align: right;">3</td>
<td style="text-align: right;">1</td>
</tr>
<tr>
<td style="text-align: left;">Hornet Sportabout</td>
<td style="text-align: right;">18.7</td>
<td style="text-align: right;">8</td>
<td style="text-align: right;">360</td>
<td style="text-align: right;">175</td>
<td style="text-align: right;">3.15</td>
<td style="text-align: right;">3.440</td>
<td style="text-align: right;">17.02</td>
<td style="text-align: right;">0</td>
<td style="text-align: right;">0</td>
<td style="text-align: right;">3</td>
<td style="text-align: right;">2</td>
</tr>
<tr>
<td style="text-align: left;">Valiant</td>
<td style="text-align: right;">18.1</td>
<td style="text-align: right;">6</td>
<td style="text-align: right;">225</td>
<td style="text-align: right;">105</td>
<td style="text-align: right;">2.76</td>
<td style="text-align: right;">3.460</td>
<td style="text-align: right;">20.22</td>
<td style="text-align: right;">1</td>
<td style="text-align: right;">0</td>
<td style="text-align: right;">3</td>
<td style="text-align: right;">1</td>
</tr>
</tbody>
</table>

``` r
# collect(mtcars_from_db)
```

## Grafico de disp vs mpg

Esta secao mostra um grafico de `disp` vs `mgp`.

-   numero de linhas: 32

``` r
collect(mtcars_from_db) |> 
    ggplot(aes(x = disp, y = mpg))  +
    geom_smooth(se = FALSE) +
    geom_point(aes(colour = as.character(gear)))
```

    `geom_smooth()` using method = 'loess' and formula = 'y ~ x'

![](README.markdown_strict_files/figure-markdown_strict/unnamed-chunk-7-1.png)

``` r
mtcars_from_db |> 
    group_by(gear) |> 
    summarise(
        across(starts_with("d"), mean),
    ) |> 
    kable()
```

<table>
<thead>
<tr>
<th style="text-align: right;">gear</th>
<th style="text-align: right;">disp</th>
<th style="text-align: right;">drat</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align: right;">3</td>
<td style="text-align: right;">326.3000</td>
<td style="text-align: right;">3.132667</td>
</tr>
<tr>
<td style="text-align: right;">4</td>
<td style="text-align: right;">123.0167</td>
<td style="text-align: right;">4.043333</td>
</tr>
<tr>
<td style="text-align: right;">5</td>
<td style="text-align: right;">202.4800</td>
<td style="text-align: right;">3.916000</td>
</tr>
</tbody>
</table>

``` r
p <- lakers |> 
    mutate(
        date = as_date(as.character(date), format = "%Y%m%d")
    ) |> 
    ggplot(aes(x = date, y = points)) +
    stat_summary() +
    scale_x_date()

p
```

![](README.markdown_strict_files/figure-markdown_strict/unnamed-chunk-9-1.png)

``` python
import sys

print(f"Versão do Py: {sys.version}")
```

    Versão do Py: 3.12.11 (main, Jun  4 2025, 17:36:43) [Clang 20.1.4 ]

``` python
2+2
```

    4
