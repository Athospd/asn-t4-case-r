# Relatorio Mensal
Athos Petri Damiani
2025-06-03

<link href="README_files/libs/htmltools-fill-0.5.8.1/fill.css" rel="stylesheet" />
<script src="README_files/libs/htmlwidgets-1.6.4/htmlwidgets.js"></script>
<script src="README_files/libs/plotly-binding-4.10.4/plotly.js"></script>
<script src="README_files/libs/typedarray-0.1/typedarray.min.js"></script>
<script src="README_files/libs/jquery-3.5.1/jquery.min.js"></script>
<link href="README_files/libs/crosstalk-1.2.1/css/crosstalk.min.css" rel="stylesheet" />
<script src="README_files/libs/crosstalk-1.2.1/js/crosstalk.min.js"></script>
<link href="README_files/libs/plotly-htmlwidgets-css-2.11.1/plotly-htmlwidgets.css" rel="stylesheet" />
<script src="README_files/libs/plotly-main-2.11.1/plotly-latest.min.js"></script>


``` r
Sys.getenv("TESTE", "nao encontrou o env TESTE")
```

    [1] "Encontrou o ENV TESTE configurado no Settings do Github Actions do Repositorio"

``` r
mtcars_from_local = mtcars |> rownames_to_column("car_id")

mtcars_no_db <- copy_to(sc, mtcars_from_local, "mtcars_from_local", overwrite = TRUE)

spark_write_table(mtcars_no_db, name = "mtcars_from_local", mode = "overwrite")
```

``` r
# mtcars_from_db <- sdf_sql(sc, "SELECT * FROM databricks_asn.default.mtcars_id")
mtcars_from_db <- tbl(sc, "mtcars_from_local")
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
<th style="text-align: left;">car_id</th>
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
collect(mtcars_from_db) |> 
    ggplot(aes(x = disp, y = mpg))  +
    geom_smooth(se = FALSE) +
    geom_point(aes(colour = as.character(gear)))
```

    `geom_smooth()` using method = 'loess' and formula = 'y ~ x'

![](README.markdown_strict_files/figure-markdown_strict/unnamed-chunk-6-1.png)

``` r
mtcars_from_db |> 
    group_by(gear) |> 
    summarise(
        across(starts_with("d"), mean),
    ) |> 
    kable()
```

    Warning: Missing values are always removed in SQL aggregation functions.
    Use `na.rm = TRUE` to silence this warning
    This warning is displayed once every 8 hours.

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
<td style="text-align: right;">4</td>
<td style="text-align: right;">123.0167</td>
<td style="text-align: right;">4.043333</td>
</tr>
<tr>
<td style="text-align: right;">3</td>
<td style="text-align: right;">326.3000</td>
<td style="text-align: right;">3.132667</td>
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

ggplotly(p)
```

<div class="plotly html-widget html-fill-item" id="htmlwidget-4fcf179efe1d18906124" style="width:672px;height:480px;"></div>
<script type="application/json" data-for="htmlwidget-4fcf179efe1d18906124">{"x":{"data":[{"x":[14180,14181,14184,14188,14192,14194,14197,14201,14203,14204,14206,14208,14211,14213,14215,14216,14218,14220,14222,14223,14225,14227,14229,14232,14233,14235,14236,14238,14246,14248,14250,14251,14253,14255,14257,14258,14260,14263,14265,14266,14269,14274,14275,14277,14279,14280,14283,14285,14292,14293,14295,14297,14299,14301,14302,14304,14306,14309,14312,14314,14315,14318,14320,14322,14324,14327,14329,14330,14332,14334,14335,14337,14339,14341,14343,14344,14346,14348],"y":[0.41346153846153844,0.43076923076923079,0.40770791075050711,0.38568588469184889,0.45411764705882351,0.41247484909456739,0.45372460496613998,0.44642857142857145,0.48048780487804876,0.45539906103286387,0.51954022988505744,0.43558282208588955,0.55388471177944865,0.47098214285714285,0.48254620123203285,0.52427184466019416,0.47945205479452052,0.4020408163265306,0.4662309368191721,0.51020408163265307,0.45073375262054505,0.4191343963553531,0.5168539325842697,0.40366972477064222,0.44,0.47971360381861577,0.44,0.44080604534005036,0.45222929936305734,0.42562929061784899,0.51276102088167053,0.48140043763676149,0.52631578947368418,0.47228381374722839,0.51507537688442206,0.58839050131926118,0.43892339544513459,0.47890818858560796,0.52699228791773778,0.52709359605911332,0.42890442890442892,0.50912778904665312,0.49305555555555558,0.50310559006211175,0.51034482758620692,0.44785276073619634,0.45823389021479716,0.43283582089552236,0.38004246284501064,0.53648068669527893,0.46694214876033058,0.50694444444444442,0.47505938242280282,0.52422907488986781,0.34931506849315069,0.47708333333333336,0.42922374429223742,0.449438202247191,0.47453703703703703,0.48058252427184467,0.5,0.47368421052631576,0.47222222222222221,0.47619047619047616,0.49130434782608695,0.47804878048780486,0.42039800995024873,0.45622119815668205,0.37413394919168591,0.43203883495145629,0.45495495495495497,0.40371229698375871,0.37284482758620691,0.51716247139588101,0.43775100401606426,0.43776824034334766,0.41031941031941033,0.50318471337579618],"text":["date: 2008-10-28<br />points: 0.4134615","date: 2008-10-29<br />points: 0.4307692","date: 2008-11-01<br />points: 0.4077079","date: 2008-11-05<br />points: 0.3856859","date: 2008-11-09<br />points: 0.4541176","date: 2008-11-11<br />points: 0.4124748","date: 2008-11-14<br />points: 0.4537246","date: 2008-11-18<br />points: 0.4464286","date: 2008-11-20<br />points: 0.4804878","date: 2008-11-21<br />points: 0.4553991","date: 2008-11-23<br />points: 0.5195402","date: 2008-11-25<br />points: 0.4355828","date: 2008-11-28<br />points: 0.5538847","date: 2008-11-30<br />points: 0.4709821","date: 2008-12-02<br />points: 0.4825462","date: 2008-12-03<br />points: 0.5242718","date: 2008-12-05<br />points: 0.4794521","date: 2008-12-07<br />points: 0.4020408","date: 2008-12-09<br />points: 0.4662309","date: 2008-12-10<br />points: 0.5102041","date: 2008-12-12<br />points: 0.4507338","date: 2008-12-14<br />points: 0.4191344","date: 2008-12-16<br />points: 0.5168539","date: 2008-12-19<br />points: 0.4036697","date: 2008-12-20<br />points: 0.4400000","date: 2008-12-22<br />points: 0.4797136","date: 2008-12-23<br />points: 0.4400000","date: 2008-12-25<br />points: 0.4408060","date: 2009-01-02<br />points: 0.4522293","date: 2009-01-04<br />points: 0.4256293","date: 2009-01-06<br />points: 0.5127610","date: 2009-01-07<br />points: 0.4814004","date: 2009-01-09<br />points: 0.5263158","date: 2009-01-11<br />points: 0.4722838","date: 2009-01-13<br />points: 0.5150754","date: 2009-01-14<br />points: 0.5883905","date: 2009-01-16<br />points: 0.4389234","date: 2009-01-19<br />points: 0.4789082","date: 2009-01-21<br />points: 0.5269923","date: 2009-01-22<br />points: 0.5270936","date: 2009-01-25<br />points: 0.4289044","date: 2009-01-30<br />points: 0.5091278","date: 2009-01-31<br />points: 0.4930556","date: 2009-02-02<br />points: 0.5031056","date: 2009-02-04<br />points: 0.5103448","date: 2009-02-05<br />points: 0.4478528","date: 2009-02-08<br />points: 0.4582339","date: 2009-02-10<br />points: 0.4328358","date: 2009-02-17<br />points: 0.3800425","date: 2009-02-18<br />points: 0.5364807","date: 2009-02-20<br />points: 0.4669421","date: 2009-02-22<br />points: 0.5069444","date: 2009-02-24<br />points: 0.4750594","date: 2009-02-26<br />points: 0.5242291","date: 2009-02-27<br />points: 0.3493151","date: 2009-03-01<br />points: 0.4770833","date: 2009-03-03<br />points: 0.4292237","date: 2009-03-06<br />points: 0.4494382","date: 2009-03-09<br />points: 0.4745370","date: 2009-03-11<br />points: 0.4805825","date: 2009-03-12<br />points: 0.5000000","date: 2009-03-15<br />points: 0.4736842","date: 2009-03-17<br />points: 0.4722222","date: 2009-03-19<br />points: 0.4761905","date: 2009-03-21<br />points: 0.4913043","date: 2009-03-24<br />points: 0.4780488","date: 2009-03-26<br />points: 0.4203980","date: 2009-03-27<br />points: 0.4562212","date: 2009-03-29<br />points: 0.3741339","date: 2009-03-31<br />points: 0.4320388","date: 2009-04-01<br />points: 0.4549550","date: 2009-04-03<br />points: 0.4037123","date: 2009-04-05<br />points: 0.3728448","date: 2009-04-07<br />points: 0.5171625","date: 2009-04-09<br />points: 0.4377510","date: 2009-04-10<br />points: 0.4377682","date: 2009-04-12<br />points: 0.4103194","date: 2009-04-14<br />points: 0.5031847"],"type":"scatter","mode":"lines+markers","opacity":1,"line":{"color":"transparent"},"error_y":{"array":[0.041747385040213858,0.038961269160521339,0.035695121270203745,0.035553298667335087,0.041833352472892216,0.035372697852401602,0.039389625801300787,0.036435760694776664,0.04411478519723222,0.040953330357647644,0.042473941936935211,0.036631986330809163,0.047253737398691431,0.040816435208324175,0.038212485224739634,0.043250764118109575,0.041226295925009204,0.034897045162071649,0.040229537314988184,0.042482979580941493,0.038013277456925565,0.03916091285283263,0.042155914690145013,0.039702184615609759,0.038575570208644383,0.042380758124605122,0.040441514477449314,0.043234118544789146,0.036360809983665698,0.039998802804252998,0.042937504347402178,0.039557559202225645,0.040935902025484139,0.041194504214654759,0.044536832045193542,0.04941257860860826,0.038826160901705931,0.045034866517734307,0.044802959171360346,0.043921524897803321,0.039264970794798459,0.038375596547178259,0.041064818508374956,0.038592972776423151,0.042105671718264293,0.038674192170747357,0.042343121931081529,0.038369152015531705,0.036379269256703428,0.041426846593171973,0.039049538115478066,0.042605381349669069,0.04125807743048665,0.042256556829378566,0.034479838381011374,0.038778536121425622,0.039278809360850153,0.039361255439236409,0.0424627423778004,0.041727956259635102,0.045495624503698595,0.042425774005251105,0.043552046415659018,0.040144521999890492,0.04077056971504317,0.041463940811821032,0.040464844091995911,0.042011008366174551,0.038647360709569811,0.041461920165585142,0.039706070018506456,0.038990807434544139,0.035745385384423234,0.042188448978093818,0.035308899545694994,0.038709588290521235,0.040458024663864667,0.038711763543219924],"arrayminus":[0.041747385040213858,0.038961269160521339,0.035695121270203745,0.035553298667335087,0.041833352472892216,0.035372697852401602,0.039389625801300787,0.036435760694776664,0.04411478519723222,0.040953330357647644,0.042473941936935267,0.036631986330809163,0.047253737398691431,0.040816435208324175,0.03821248522473969,0.043250764118109575,0.041226295925009204,0.034897045162071649,0.040229537314988129,0.042482979580941493,0.038013277456925565,0.03916091285283263,0.042155914690144958,0.039702184615609759,0.038575570208644383,0.042380758124605122,0.040441514477449314,0.043234118544789146,0.036360809983665698,0.039998802804252998,0.042937504347402178,0.039557559202225645,0.040935902025484194,0.041194504214654759,0.044536832045193597,0.04941257860860826,0.038826160901705931,0.045034866517734307,0.044802959171360401,0.043921524897803266,0.039264970794798459,0.038375596547178203,0.041064818508375012,0.038592972776423151,0.042105671718264293,0.038674192170747357,0.042343121931081584,0.038369152015531705,0.036379269256703428,0.041426846593172029,0.039049538115478066,0.042605381349669125,0.041258077430486706,0.042256556829378566,0.034479838381011374,0.038778536121425677,0.039278809360850153,0.039361255439236409,0.0424627423778004,0.041727956259635102,0.045495624503698595,0.042425774005251105,0.043552046415659018,0.040144521999890492,0.04077056971504317,0.041463940811820976,0.040464844091995911,0.042011008366174551,0.038647360709569811,0.041461920165585142,0.039706070018506456,0.038990807434544139,0.035745385384423234,0.042188448978093818,0.035308899545694994,0.038709588290521235,0.040458024663864667,0.038711763543219979],"type":"data","width":0,"symmetric":false,"color":"rgba(0,0,0,1)"},"showlegend":false,"xaxis":"x","yaxis":"y","hoverinfo":"text","marker":{"autocolorscale":false,"color":"rgba(0,0,0,1)","opacity":1,"size":1.8897637795275593,"symbol":"circle","line":{"width":3.7795275590551185,"color":"rgba(0,0,0,1)"}},"hoveron":"points","frame":null}],"layout":{"margin":{"t":26.228310502283104,"r":7.3059360730593621,"b":40.182648401826491,"l":43.105022831050235},"plot_bgcolor":"rgba(235,235,235,1)","paper_bgcolor":"rgba(255,255,255,1)","font":{"color":"rgba(0,0,0,1)","family":"","size":14.611872146118724},"xaxis":{"domain":[0,1],"automargin":true,"type":"linear","autorange":false,"range":[14171.6,14356.4],"tickmode":"array","ticktext":["Nov","Dec","Jan","Feb","Mar","Apr"],"tickvals":[14184,14214,14245,14276,14304,14335],"categoryorder":"array","categoryarray":["Nov","Dec","Jan","Feb","Mar","Apr"],"nticks":null,"ticks":"outside","tickcolor":"rgba(51,51,51,1)","ticklen":3.6529680365296811,"tickwidth":0.66417600664176002,"showticklabels":true,"tickfont":{"color":"rgba(77,77,77,1)","family":"","size":11.68949771689498},"tickangle":-0,"showline":false,"linecolor":null,"linewidth":0,"showgrid":true,"gridcolor":"rgba(255,255,255,1)","gridwidth":0.66417600664176002,"zeroline":false,"anchor":"y","title":{"text":"date","font":{"color":"rgba(0,0,0,1)","family":"","size":14.611872146118724}},"hoverformat":".2f"},"yaxis":{"domain":[0,1],"automargin":true,"type":"linear","autorange":false,"range":[0.29868683762135284,0.65395147241865592],"tickmode":"array","ticktext":["0.3","0.4","0.5","0.6"],"tickvals":[0.30000000000000004,0.40000000000000002,0.5,0.60000000000000009],"categoryorder":"array","categoryarray":["0.3","0.4","0.5","0.6"],"nticks":null,"ticks":"outside","tickcolor":"rgba(51,51,51,1)","ticklen":3.6529680365296811,"tickwidth":0.66417600664176002,"showticklabels":true,"tickfont":{"color":"rgba(77,77,77,1)","family":"","size":11.68949771689498},"tickangle":-0,"showline":false,"linecolor":null,"linewidth":0,"showgrid":true,"gridcolor":"rgba(255,255,255,1)","gridwidth":0.66417600664176002,"zeroline":false,"anchor":"x","title":{"text":"points","font":{"color":"rgba(0,0,0,1)","family":"","size":14.611872146118724}},"hoverformat":".2f"},"shapes":[{"type":"rect","fillcolor":null,"line":{"color":null,"width":0,"linetype":[]},"yref":"paper","xref":"paper","x0":0,"x1":1,"y0":0,"y1":1}],"showlegend":false,"legend":{"bgcolor":"rgba(255,255,255,1)","bordercolor":"transparent","borderwidth":1.8897637795275593,"font":{"color":"rgba(0,0,0,1)","family":"","size":11.68949771689498}},"hovermode":"closest","barmode":"relative"},"config":{"doubleClick":"reset","modeBarButtonsToAdd":["hoverclosest","hovercompare"],"showSendToCloud":false},"source":"A","attrs":{"23dc5d3fb5f0":{"x":{},"y":{},"type":"scatter"}},"cur_data":"23dc5d3fb5f0","visdat":{"23dc5d3fb5f0":["function (y) ","x"]},"highlight":{"on":"plotly_click","persistent":false,"dynamic":false,"selectize":false,"opacityDim":0.20000000000000001,"selected":{"opacity":1},"debounce":0},"shinyEvents":["plotly_hover","plotly_click","plotly_selected","plotly_relayout","plotly_brushed","plotly_brushing","plotly_clickannotation","plotly_doubleclick","plotly_deselect","plotly_afterplot","plotly_sunburstclick"],"base_url":"https://plot.ly"},"evals":[],"jsHooks":[]}</script>
