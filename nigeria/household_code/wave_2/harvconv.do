*Wave 2, Nigeria Harvest Converions - producing file for conversions

use "/Users/alisonconley/Dropbox/Weather_Project/Data/Nigeria/analysis_datasets/Nigeria_raw/conversion_files/wave_2/w2agnsconversion.dta", clear

rename nscode harv_unit

tab cropcode, nolabel

*trying to get kgs into dataset
set obs 2178
replace cropcode = 1010 in 2178
set obs 2179
replace cropcode = 1020 in 2179
set obs 2180
replace cropcode = 1040 in 2180
set obs 2181
replace cropcode = 1050 in 2181
set obs 2182
replace cropcode = 1051 in 2182
set obs 2183
replace cropcode = 1052 in 2183
set obs 2184
replace cropcode = 1053 in 2184
set obs 2185
replace cropcode = 1060 in 2185
set obs 2186
replace cropcode = 1061 in 2186
set obs 2187
replace cropcode = 1062 in 2187
set obs 2188
replace cropcode = 1070 in 2188
set obs 2189
replace cropcode = 1080 in 2189
set obs 2190
replace cropcode = 1081 in 2190
set obs 2191
replace cropcode = 1082 in 2191
set obs 2192
replace cropcode = 1083 in 2192
set obs 2193
replace cropcode = 1090 in 2193
set obs 2194
replace cropcode = 1091 in 2194
set obs 2195
replace cropcode = 1092 in 2195
set obs 2196
replace cropcode = 1093 in 2196
set obs 2197
replace cropcode = 1100 in 2197
set obs 2198
replace cropcode = 1110 in 2198
set obs 2199
replace cropcode = 1111 in 2199
set obs 2200
replace cropcode = 1112 in 2200
set obs 2201
replace cropcode = 1122 in 2201
set obs 2202
replace cropcode = 1123 in 2202
set obs 2203
replace cropcode = 1124 in 2203
set obs 2204
replace cropcode = 2010 in 2204
set obs 2205
replace cropcode = 2020 in 2205
set obs 2206
replace cropcode = 2030 in 2206
set obs 2207
replace cropcode = 2040 in 2207
set obs 2208
replace cropcode = 2050 in 2208
set obs 2209
replace cropcode = 2060 in 2209
set obs 2210
replace cropcode = 2070 in 2210
set obs 2211
replace cropcode = 2071 in 2211
set obs 2212
replace cropcode = 2080 in 2212
set obs 2213
replace cropcode = 2090 in 2213
set obs 2214
replace cropcode = 2100 in 2214
set obs 2215
replace cropcode = 2101 in 2215
set obs 2216
replace cropcode = 2102 in 2216
set obs 2217
replace cropcode = 2103 in 2217
set obs 2218
replace cropcode = 2110 in 2218
set obs 2219
replace cropcode = 2120 in 2219
set obs 2220
replace cropcode = 2130 in 2220
set obs 2221
replace cropcode = 2140 in 2221
set obs 2222
replace cropcode = 2141 in 2222
set obs 2223
replace cropcode = 2142 in 2223
set obs 2224
replace cropcode = 2143 in 2224
set obs 2225
replace cropcode = 2150 in 2225
set obs 2226
replace cropcode = 2160 in 2226
set obs 2227
replace cropcode = 2170 in 2227
set obs 2228
replace cropcode = 2180 in 2228
set obs 2229
replace cropcode = 2190 in 2229
set obs 2230
replace cropcode = 2191 in 2230
set obs 2231
replace cropcode = 2192 in 2231
set obs 2232
replace cropcode = 2193 in 2232
set obs 2233
replace cropcode = 2194 in 2233
set obs 2234
replace cropcode = 2195 in 2234
set obs 2235
replace cropcode = 2200 in 2235
set obs 2236
replace cropcode = 2210 in 2236
set obs 2237
replace cropcode = 2220 in 2237
set obs 2238
replace cropcode = 2230 in 2238
set obs 2239
replace cropcode = 2240 in 2239
set obs 2240
replace cropcode = 2250 in 2240
set obs 2241
replace cropcode = 2260 in 2241
set obs 2242
replace cropcode = 2270 in 2242
set obs 2243
replace cropcode = 2280 in 2243
set obs 2244
replace cropcode = 2290 in 2244
set obs 2245
replace cropcode = 2291 in 2245
set obs 2246
replace cropcode = 3010 in 2246
set obs 2247
replace cropcode = 3020 in 2247
set obs 2248
replace cropcode = 3021 in 2248
set obs 2249
replace cropcode = 3022 in 2249
set obs 2250
replace cropcode = 3030 in 2250
set obs 2251
replace cropcode = 3040 in 2251
set obs 2252
replace cropcode = 3041 in 2252
set obs 2253
replace cropcode = 3042 in 2253
set obs 2254
replace cropcode = 3050 in 2254
set obs 2255
replace cropcode = 3060 in 2255
set obs 2256
replace cropcode = 3061 in 2256
set obs 2257
replace cropcode = 3062 in 2257
set obs 2258
replace cropcode = 3080 in 2258
set obs 2259
replace cropcode = 3090 in 2259
set obs 2260
replace cropcode = 3100 in 2260
set obs 2261
replace cropcode = 3110 in 2261
set obs 2262
replace cropcode = 3110 in 2262
replace cropcode = 3111 in 2262
set obs 2263
replace cropcode = 3112 in 2263
set obs 2264
replace cropcode = 3113 in 2264
set obs 2265
replace cropcode = 3120 in 2265
set obs 2266
replace cropcode = 3130 in 2266
set obs 2267
replace cropcode = 3140 in 2267
set obs 2268
replace cropcode = 3150 in 2268
set obs 2269
replace cropcode = 3160 in 2269
set obs 2270
replace cropcode = 3170 in 2270
set obs 2271
replace cropcode = 3180 in 2271
set obs 2272
replace cropcode = 3181 in 2272
set obs 2273
replace cropcode = 3182 in 2273
set obs 2274
replace cropcode = 3183 in 2274
set obs 2275
replace cropcode = 3184 in 2275
set obs 2276
replace cropcode = 3190 in 2276
set obs 2277
replace cropcode = 3200 in 2277
set obs 2278
replace cropcode = 3210 in 2278
set obs 2279
replace cropcode = 3220 in 2279
set obs 2280
replace cropcode = 3221 in 2280
set obs 2281
replace cropcode = 3230 in 2281
set obs 2282
replace cropcode = 3231 in 2282
set obs 2283
replace cropcode = 3232 in 2283
set obs 2284
replace cropcode = 3240 in 2284
set obs 2285
replace cropcode = 3250 in 2285
set obs 2286
replace cropcode = 3260 in 2286

*kgs
replace harv_unit = 1 in 2178
replace harv_unit = 1 if harv_unit ==. 
replace conversion = 1 if harv_unit ==1





save "/Users/alisonconley/Dropbox/Weather_Project/Data/Nigeria/analysis_datasets/Nigeria_raw/conversion_files/wave_2/harvconv.dta", replace
