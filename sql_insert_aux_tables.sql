-- Tabla feat_seed_types
-- DELETE FROM feat_seed_types

INSERT INTO mirnaplatform.feat_seed_types(st_id, st_name, st_description)
  VALUES (DEFAULT, 'Type 1', 'x ∈ {0,1} and x = 1 if there is perfect z2 - z8 (Watson-Crick) match');
INSERT INTO mirnaplatform.feat_seed_types(st_id, st_name, st_description)
  VALUES (DEFAULT, 'Type 2', 'x ∈ {0,1} and x = 1 if there is perfect z2 - z8 match with an A in mRNA binding with z1');
INSERT INTO mirnaplatform.feat_seed_types(st_id, st_name, st_description)
  VALUES (DEFAULT, 'Type 3', 'x ∈ {0,1} and x = 1 if there is perfect z2 - z7 match');
INSERT INTO mirnaplatform.feat_seed_types(st_id, st_name, st_description)
  VALUES (DEFAULT, 'Type 4', 'x ∈ {0,1} and x = 1 if there is perfect z1 - z6 Watson-Crick or G-U matches and at most one G-U match.');
INSERT INTO mirnaplatform.feat_seed_types(st_id, st_name, st_description)
  VALUES (DEFAULT, 'Type 5', 'x ∈ {0,1} and x = 1 if there is perfect z2 - z7 Watson-Crick or G-U matches and at most one G-U match');
INSERT INTO mirnaplatform.feat_seed_types(st_id, st_name, st_description)
  VALUES (DEFAULT, 'Type 6', 'x ∈{0,1} and x = 1 if the number of perfect matches in z1 - z8 is more than a cut-off value');
INSERT INTO mirnaplatform.feat_seed_types(st_id, st_name, st_description)
  VALUES (DEFAULT, 'Type 7', 'x ∈{0,1} and x = 1 if the number of consecutive perfect matches in z1 - z8 is more than a cut-off value');


-- Tabla feat_conservation_mirna_families
-- DELETE FROM feat_conservation_mirna_families

INSERT INTO mirnaplatform.feat_conservation_mirna_family(mf_id, mf_name, mf_description)
	VALUES (DEFAULT, 'broadly conserved', 'conserved across most vertebrates, usually to zebrafish (Supplemental Table 1 of Friedman et al.)');
INSERT INTO mirnaplatform.feat_conservation_mirna_family(mf_id, mf_name, mf_description)
	VALUES (DEFAULT, 'conserved', 'conserved across most mammals, but usually not beyond placental mammals (Supplemental Tables 2 & 3 of Friedman et al.)');
INSERT INTO mirnaplatform.feat_conservation_mirna_family(mf_id, mf_name, mf_description)
	VALUES (DEFAULT, 'poorly conserved', 'all others');


  -- Tabla feat_conservation_mirna_sites
  -- DELETE FROM feat_conservation_mirna_sites

  INSERT INTO mirnaplatform.feat_conservation_mirna_sites(ms_id, ms_name, ms_threshold, ms_description)
    VALUES (DEFAULT, '8mer', 0.8, '');
  INSERT INTO mirnaplatform.feat_conservation_mirna_sites(ms_id, ms_name, ms_threshold, ms_description)
    VALUES (DEFAULT, '7mer-m8', 1.3, '');
  INSERT INTO mirnaplatform.feat_conservation_mirna_sites(ms_id, ms_name, ms_threshold, ms_description)
    VALUES (DEFAULT, '7mer-1A', 1.8, '');


  -- Tabla feat_seed_types
  -- DELETE FROM feat_seed_types

  INSERT INTO mirnaplatform.feat_seed_regions(sr_id, sr_start, sr_end)
  VALUES (DEFAULT, 1, 8);
  INSERT INTO mirnaplatform.feat_seed_regions(sr_id, sr_start, sr_end)
  VALUES (DEFAULT, 1, 8);
  INSERT INTO mirnaplatform.feat_seed_regions(sr_id, sr_start, sr_end)
  VALUES (DEFAULT, 1, 8);

  -- Tabla datasets_ensembl
  -- DELETE FROM datasets_ensembl

  INSERT INTO mirnaplatform.datasets_ensembl VALUES (DEFAULT,'cfamiliaris_gene_ensembl', 'Dog genes (CanFam3.1)', 'CanFam3.1');
  INSERT INTO mirnaplatform.datasets_ensembl VALUES (DEFAULT,'btaurus_gene_ensembl', 'Cow genes (UMD3.1)', 'UMD3.1');
  INSERT INTO mirnaplatform.datasets_ensembl VALUES (DEFAULT,'ogarnettii_gene_ensembl', 'Bushbaby genes (OtoGar3)', 'OtoGar3');
  INSERT INTO mirnaplatform.datasets_ensembl VALUES (DEFAULT,'mmulatta_gene_ensembl', 'Macaque genes (Mmul_8.0.1)', 'Mmul_8.0.1');
  INSERT INTO mirnaplatform.datasets_ensembl VALUES (DEFAULT,'tnigroviridis_gene_ensembl', 'Tetraodon genes (TETRAODON 8.0)', 'TETRAODON 8.0');
  INSERT INTO mirnaplatform.datasets_ensembl VALUES (DEFAULT,'pformosa_gene_ensembl', 'Amazon molly genes (Poecilia_formosa-5.1.2)', 'Poecilia_formosa-5.1.2');
  INSERT INTO mirnaplatform.datasets_ensembl VALUES (DEFAULT,'ttruncatus_gene_ensembl', 'Dolphin genes (turTru1)', 'turTru1');
  INSERT INTO mirnaplatform.datasets_ensembl VALUES (DEFAULT,'nleucogenys_gene_ensembl', 'Gibbon genes (Nleu1.0)', 'Nleu1.0');
  INSERT INTO mirnaplatform.datasets_ensembl VALUES (DEFAULT,'ggallus_gene_ensembl', 'Chicken genes (Gallus_gallus-5.0)', 'Gallus_gallus-5.0');
  INSERT INTO mirnaplatform.datasets_ensembl VALUES (DEFAULT,'xtropicalis_gene_ensembl', 'Xenopus genes (JGI 4.2)', 'JGI 4.2');
  INSERT INTO mirnaplatform.datasets_ensembl VALUES (DEFAULT,'celegans_gene_ensembl', 'Caenorhabditis elegans genes (WBcel235)', 'WBcel235');
  INSERT INTO mirnaplatform.datasets_ensembl VALUES (DEFAULT,'itridecemlineatus_gene_ensembl', 'Squirrel genes (spetri2)', 'spetri2');
  INSERT INTO mirnaplatform.datasets_ensembl VALUES (DEFAULT,'mgallopavo_gene_ensembl', 'Turkey genes (Turkey_2.01)', 'Turkey_2.01');
  INSERT INTO mirnaplatform.datasets_ensembl VALUES (DEFAULT,'ptroglodytes_gene_ensembl', 'Chimpanzee genes (CHIMP2.1.4)', 'CHIMP2.1.4');
  INSERT INTO mirnaplatform.datasets_ensembl VALUES (DEFAULT,'amelanoleuca_gene_ensembl', 'Panda genes (ailMel1)', 'ailMel1');
  INSERT INTO mirnaplatform.datasets_ensembl VALUES (DEFAULT,'aplatyrhynchos_gene_ensembl', 'Duck genes (BGI_duck_1.0)', 'BGI_duck_1.0');
  INSERT INTO mirnaplatform.datasets_ensembl VALUES (DEFAULT,'ecaballus_gene_ensembl', 'Horse genes (Equ Cab 2)', 'Equ Cab 2');
  INSERT INTO mirnaplatform.datasets_ensembl VALUES (DEFAULT,'oanatinus_gene_ensembl', 'Platypus genes (OANA5)', 'OANA5');
  INSERT INTO mirnaplatform.datasets_ensembl VALUES (DEFAULT,'csabaeus_gene_ensembl', 'Vervet-AGM genes (ChlSab1.1)', 'ChlSab1.1');
  INSERT INTO mirnaplatform.datasets_ensembl VALUES (DEFAULT,'etelfairi_gene_ensembl', 'Lesser hedgehog tenrec genes (TENREC)', 'TENREC');
  INSERT INTO mirnaplatform.datasets_ensembl VALUES (DEFAULT,'xmaculatus_gene_ensembl', 'Platyfish genes (Xipmac4.4.2)', 'Xipmac4.4.2');
  INSERT INTO mirnaplatform.datasets_ensembl VALUES (DEFAULT,'amexicanus_gene_ensembl', 'Cave fish genes (AstMex102)', 'AstMex102');
  INSERT INTO mirnaplatform.datasets_ensembl VALUES (DEFAULT,'mmusculus_gene_ensembl', 'Mouse genes (GRCm38.p5)', 'GRCm38.p5');
  INSERT INTO mirnaplatform.datasets_ensembl VALUES (DEFAULT,'falbicollis_gene_ensembl', 'Flycatcher genes (FicAlb_1.4)', 'FicAlb_1.4');
  INSERT INTO mirnaplatform.datasets_ensembl VALUES (DEFAULT,'rnorvegicus_gene_ensembl', 'Rat genes (Rnor_6.0)', 'Rnor_6.0');
  INSERT INTO mirnaplatform.datasets_ensembl VALUES (DEFAULT,'gaculeatus_gene_ensembl', 'Stickleback genes (BROAD S1)', 'BROAD S1');
  INSERT INTO mirnaplatform.datasets_ensembl VALUES (DEFAULT,'pabelii_gene_ensembl', 'Orangutan genes (PPYG2)', 'PPYG2');
  INSERT INTO mirnaplatform.datasets_ensembl VALUES (DEFAULT,'acarolinensis_gene_ensembl', 'Anole lizard genes (AnoCar2.0)', 'AnoCar2.0');
  INSERT INTO mirnaplatform.datasets_ensembl VALUES (DEFAULT,'cintestinalis_gene_ensembl', 'C.intestinalis genes (KH)', 'KH');
  INSERT INTO mirnaplatform.datasets_ensembl VALUES (DEFAULT,'loculatus_gene_ensembl', 'Spotted gar genes (LepOcu1)', 'LepOcu1');
  INSERT INTO mirnaplatform.datasets_ensembl VALUES (DEFAULT,'oaries_gene_ensembl', 'Sheep genes (Oar_v3.1)', 'Oar_v3.1');
  INSERT INTO mirnaplatform.datasets_ensembl VALUES (DEFAULT,'mlucifugus_gene_ensembl', 'Microbat genes (Myoluc2.0)', 'Myoluc2.0');
  INSERT INTO mirnaplatform.datasets_ensembl VALUES (DEFAULT,'meugenii_gene_ensembl', 'Wallaby genes (Meug_1.0)', 'Meug_1.0');
  INSERT INTO mirnaplatform.datasets_ensembl VALUES (DEFAULT,'eeuropaeus_gene_ensembl', 'Hedgehog genes (eriEur1)', 'eriEur1');
  INSERT INTO mirnaplatform.datasets_ensembl VALUES (DEFAULT,'pvampyrus_gene_ensembl', 'Megabat genes (pteVam1)', 'pteVam1');
  INSERT INTO mirnaplatform.datasets_ensembl VALUES (DEFAULT,'pmarinus_gene_ensembl', 'Lamprey genes (Pmarinus_7.0)', 'Pmarinus_7.0');
  INSERT INTO mirnaplatform.datasets_ensembl VALUES (DEFAULT,'pcapensis_gene_ensembl', 'Hyrax genes (proCap1)', 'proCap1');
  INSERT INTO mirnaplatform.datasets_ensembl VALUES (DEFAULT,'vpacos_gene_ensembl', 'Alpaca genes (vicPac1)', 'vicPac1');
  INSERT INTO mirnaplatform.datasets_ensembl VALUES (DEFAULT,'fcatus_gene_ensembl', 'Cat genes (Felis_catus_6.2)', 'Felis_catus_6.2');
  INSERT INTO mirnaplatform.datasets_ensembl VALUES (DEFAULT,'oniloticus_gene_ensembl', 'Tilapia genes (Orenil1.0)', 'Orenil1.0');
  INSERT INTO mirnaplatform.datasets_ensembl VALUES (DEFAULT,'lchalumnae_gene_ensembl', 'Coelacanth genes (LatCha1)', 'LatCha1');
  INSERT INTO mirnaplatform.datasets_ensembl VALUES (DEFAULT,'dmelanogaster_gene_ensembl', 'Fruitfly genes (BDGP6)', 'BDGP6');
  INSERT INTO mirnaplatform.datasets_ensembl VALUES (DEFAULT,'gmorhua_gene_ensembl', 'Cod genes (gadMor1)', 'gadMor1');
  INSERT INTO mirnaplatform.datasets_ensembl VALUES (DEFAULT,'panubis_gene_ensembl', 'Olive baboon genes (PapAnu2.0)', 'PapAnu2.0');
  INSERT INTO mirnaplatform.datasets_ensembl VALUES (DEFAULT,'dnovemcinctus_gene_ensembl', 'Armadillo genes (Dasnov3.0)', 'Dasnov3.0');
  INSERT INTO mirnaplatform.datasets_ensembl VALUES (DEFAULT,'sharrisii_gene_ensembl', 'Tasmanian devil genes (Devil_ref v7.0)', 'Devil_ref v7.0');
  INSERT INTO mirnaplatform.datasets_ensembl VALUES (DEFAULT,'dordii_gene_ensembl', 'Kangaroo rat genes (dipOrd1)', 'dipOrd1');
  INSERT INTO mirnaplatform.datasets_ensembl VALUES (DEFAULT,'lafricana_gene_ensembl', 'Elephant genes (Loxafr3.0)', 'Loxafr3.0');
  INSERT INTO mirnaplatform.datasets_ensembl VALUES (DEFAULT,'saraneus_gene_ensembl', 'Shrew genes (sorAra1)', 'sorAra1');
  INSERT INTO mirnaplatform.datasets_ensembl VALUES (DEFAULT,'choffmanni_gene_ensembl', 'Sloth genes (choHof1)', 'choHof1');
  INSERT INTO mirnaplatform.datasets_ensembl VALUES (DEFAULT,'oprinceps_gene_ensembl', 'Pika genes (OchPri2.0-Ens)', 'OchPri2.0-Ens');
  INSERT INTO mirnaplatform.datasets_ensembl VALUES (DEFAULT,'mdomestica_gene_ensembl', 'Opossum genes (monDom5)', 'monDom5');
  INSERT INTO mirnaplatform.datasets_ensembl VALUES (DEFAULT,'ocuniculus_gene_ensembl', 'Rabbit genes (OryCun2.0)', 'OryCun2.0');
  INSERT INTO mirnaplatform.datasets_ensembl VALUES (DEFAULT,'scerevisiae_gene_ensembl', 'Saccharomyces cerevisiae genes (R64-1-1)', 'R64-1-1');
  INSERT INTO mirnaplatform.datasets_ensembl VALUES (DEFAULT,'psinensis_gene_ensembl', 'Chinese softshell turtle genes (PelSin_1.0)', 'PelSin_1.0');
  INSERT INTO mirnaplatform.datasets_ensembl VALUES (DEFAULT,'tguttata_gene_ensembl', 'Zebra Finch genes (taeGut3.2.4)', 'taeGut3.2.4');
  INSERT INTO mirnaplatform.datasets_ensembl VALUES (DEFAULT,'sscrofa_gene_ensembl', 'Pig genes (Sscrofa10.2)', 'Sscrofa10.2');
  INSERT INTO mirnaplatform.datasets_ensembl VALUES (DEFAULT,'tbelangeri_gene_ensembl', 'Tree Shrew genes (tupBel1)', 'tupBel1');
  INSERT INTO mirnaplatform.datasets_ensembl VALUES (DEFAULT,'ggorilla_gene_ensembl', 'Gorilla genes (gorGor3.1)', 'gorGor3.1');
  INSERT INTO mirnaplatform.datasets_ensembl VALUES (DEFAULT,'drerio_gene_ensembl', 'Zebrafish genes (GRCz10)', 'GRCz10');
  INSERT INTO mirnaplatform.datasets_ensembl VALUES (DEFAULT,'tsyrichta_gene_ensembl', 'Tarsier genes (tarSyr1)', 'tarSyr1');
  INSERT INTO mirnaplatform.datasets_ensembl VALUES (DEFAULT,'trubripes_gene_ensembl', 'Fugu genes (FUGU 4.0)', 'FUGU 4.0');
  INSERT INTO mirnaplatform.datasets_ensembl VALUES (DEFAULT,'mfuro_gene_ensembl', 'Ferret genes (MusPutFur1.0)', 'MusPutFur1.0');
  INSERT INTO mirnaplatform.datasets_ensembl VALUES (DEFAULT,'hsapiens_gene_ensembl', 'Human genes (GRCh38.p10)', 'GRCh38.p10');
  INSERT INTO mirnaplatform.datasets_ensembl VALUES (DEFAULT,'cjacchus_gene_ensembl', 'Marmoset genes (C_jacchus3.2.1)', 'C_jacchus3.2.1');
  INSERT INTO mirnaplatform.datasets_ensembl VALUES (DEFAULT,'cporcellus_gene_ensembl', 'Guinea Pig genes (cavPor3)', 'cavPor3');
  INSERT INTO mirnaplatform.datasets_ensembl VALUES (DEFAULT,'olatipes_gene_ensembl', 'Medaka genes (HdrR)', 'HdrR');
  INSERT INTO mirnaplatform.datasets_ensembl VALUES (DEFAULT,'mmurinus_gene_ensembl', 'Mouse Lemur genes (Mmur_2.0)', 'Mmur_2.0');
  INSERT INTO mirnaplatform.datasets_ensembl VALUES (DEFAULT,'csavignyi_gene_ensembl', 'C.savignyi genes (CSAV 2.0)', 'CSAV 2.0');
  INSERT INTO mirnaplatform.datasets_ensembl VALUES (DEFAULT,'Todos', 'Selección de todos los datasets', 'v1');
