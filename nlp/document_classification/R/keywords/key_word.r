source('keywords/synonym.r')

Age <-  unique(     stri_trans_totitle(c(.syn_c('age','Exact'),.syn_c('birthday')))  )
Sex <- unique(     stri_trans_totitle(c(.syn_c('male'),.syn_c('female'),.syn_c('gender')))  )
Twin <- unique(     stri_trans_totitle(c(.syn_c('twin','exact'),.syn_c('zygotic',,T),.syn_c('uplet')))  )
Birth_place <- unique(     stri_trans_totitle(c(.syn_c('birthplace',,T)))  )
Citizenship <- unique(     stri_trans_totitle(c(.syn_c('citizen',,T),.syn_c('immigration'),.syn_c('naturalization')))  )
Ethnic_race_religion <-  unique(     stri_trans_totitle(c(.syn_c('ethnic',,T),.syn_c('religion',,T)))  )
Language <- unique(     stri_trans_totitle(c(.syn_c('language'),.syn_c('dialect')))  )
Residence <- unique(     stri_trans_totitle(c(.syn_c('residence',,T),.syn_c('domicile',,T), .syn_c('habitation')))  )
Marital_status <- unique(     stri_trans_totitle(c(.syn_c('wedlock',,T),.syn_c('matrimony',,T)))  )
Family_hh_struct <- unique(     stri_trans_totitle(c(.syn_c('family','Exact',T),.syn_c('household','Exact',T)))  )
Education <- unique(     stri_trans_totitle(c(.syn_c('degree'),.syn_c('education')))  )
Labour_retirement <- unique(     stri_trans_totitle(c(.syn_c('worker'),.syn_c('employment'), .syn_c('job'), .syn_c('apprentice')))  )
Income <- unique(     stri_trans_totitle(c(.syn_c('revenue'),.syn_c('income',,T), .syn_c('salary')))  )
Tobacco <- unique(     stri_trans_totitle(c(.syn_c('smoker'),.syn_c('cigar')))  )
Alcohol <- Alcohol <- unique( stri_trans_totitle(c(.syn_c('wine','exact',T),.syn_c('liquor','exact',T), .syn_c('beer','exact',T), .syn_c('whisky','exact',T), .syn_c('alcoholic')))  )
Drugs <- unique(     stri_trans_totitle(c(.syn_c('ecstasy','exact'),.syn_c('amphetamine'), .syn_c('cocain'), .syn_c('marijuana'),.syn_c('lsd') ))  )
Nutrition <- unique(     stri_trans_totitle(c(.syn_c('nutrition'), .syn_c('nutrient','exact'), .syn_c('snack','exact'), .syn_c('meal','exact') ,.syn_c('lunch','exact'), .syn_c('fat','exact')))  )
Phys_act <- unique(     stri_trans_totitle(c(.syn_c('vigor','exact'),.syn_c('exercise','exact')))  )
Pers_hygiene <- unique(     stri_trans_totitle(c(.syn_c('cleaning','exact'),.syn_c('bathing','exact',all = T))  ))
Sleep <- unique(     stri_trans_totitle(c(.syn_c('sleep','exact'),.syn_c('insomnia')))  )
Sex_behav <- unique(     stri_trans_totitle(c(.syn_c('sexual'),.syn_c('intercourse')))  )
Transportation <- unique(     stri_trans_totitle(c(.syn_c('airplane','exact'),.syn_c('locomotion','exact'),.syn_c('automobile','exact'), .syn_c('metro','exact'),.syn_c('highway','exact'),.syn_c('transit','exact') )))
Qual_life <- unique(     stri_trans_totitle(c(.syn_c('well-being','Exact',all = T),.syn_c('self-detemination','Exact',all = T)))  )

Infectious_dis <- unique(     stri_trans_totitle(c(.syn_c('disease','Contains',T)))  )
Neoplasms <- unique(  stri_trans_totitle(c(.syn_c('neoplasm','Contains',T),.syn_c('tumor','Contains',T),.syn_c('lymphoma','Contains',T),.syn_c('cancer','Contains',T)))  )
Blood_immune_dis <- unique(     stri_trans_totitle(c(.syn_c('clotting','Contains'), .syn_c('hemophilia','Contains',T),  .syn_c('sickle-cell','Contains',T)))  )
Endocrine_metabolic_dis <-  unique(     stri_trans_totitle(c(.syn_c('diabetes','Contains'), .syn_c('goitre','Contains')))  )



#===========COMPILE===================
KW <- .cbind.na(Age,Sex,Twin,Birth_place,Citizenship,Ethnic_race_religion,Language,Residence,Marital_status,Family_hh_struct,Education,Labour_retirement,
                 Income,Tobacco,Alcohol,Drugs,Nutrition,Phys_act,Pers_hygiene,Sleep,Sex_behav,Transportation,Other_lifestyle=NA,Perc_health=NA,Qual_life=NA,
                 Act_daily_living=NA,Use_devices=NA,Other=NA, Infectious_dis,Neoplasms,Blood_immune_dis,Endocrine_metabolic_dis
                )



#------------------------------------------- V2 -----------------------------
Mental_behav_dis <-  unique(stri_trans_totitle(c(.syn_c('maniac',,T), .syn_c('anxiety',,T), .syn_c('dysfunction',,T), .syn_c('sadness',,T), .syn_c('phobia',,T), .syn_c('amnesia',,T)  )))
Nervous_sys_dis <-  unique(stri_trans_totitle(c(.syn_c('parkinston',,T), .syn_c('epilepsy',,T), .syn_c('neuropathy',,T), .syn_c('nervous',,T), .syn_c('amyotrop',,T), .syn_c('cerebral',,T) )))
Eye_adnexa_dis <-  unique(stri_trans_totitle(c(.syn_c('blindness',,T), .syn_c('myopia',,T), .syn_c('presbyop',,T), .syn_c('glaucoma',,T), .syn_c('hypermetrop',,T)  )))
Ear_mastoid_dis <-  unique(stri_trans_totitle(c(.syn_c('deaf'), .syn_c('hearing',,T), .syn_c('meniere',,T) )))
Circulatory_sys_dis <-  unique(stri_trans_totitle(c(.syn_c('hypertens',,T), .syn_c('aortic',,T), .syn_c('angina',,T), .syn_c('cva',,T), .syn_c('carditis'), .syn_c('myopath',,T), .syn_c('sclerosis'),.syn_c('aneurism')  )))
Respiratory_sys_dis <-  unique(stri_trans_totitle(c(.syn_c('respiratory'), .syn_c('pulmonary'), .syn_c('asthma',,T), .syn_c('pneumon',,T), .syn_c('bronchi'), .syn_c('grippe',,T) )))
Skin_subcutaneous_dis <-  unique(stri_trans_totitle(c(.syn_c('psorias',,T), .syn_c('dermati',,T), .syn_c('acne')  )))
Musculoskeletal_sys_dis <-  unique(stri_trans_totitle(c(.syn_c('arthritis',,T), .syn_c('aortic',,T), .syn_c('rheumatoid',,T), .syn_c('arthrosis',,T), .syn_c('osteop'), .syn_c('lordosis',,T), .syn_c('sclerosis'),.syn_c('torticol')  )))
Pregnancy_childbirth <-  unique(stri_trans_totitle(c(.syn_c('miscarriage'), .syn_c('eclamps',,T), .syn_c('gestation'), .syn_c('placenta'),.syn_c('caesarian')  )))
Perinatal_cond <-  unique(stri_trans_totitle(c(.syn_c('preterm',,T), .syn_c('foetal'), .syn_c('prematurit'), .syn_c('lordosis',,T), .syn_c('sclerosis'),.syn_c('torticol')  )))
Cong_malform_chrom_abnor <-  unique(stri_trans_totitle(c(.syn_c('abnorma',,T), .syn_c('ptosis',,T), .syn_c('microcephal',,T), .syn_c('encephaly',,T), .syn_c('congenit'), .syn_c('malforma',,T)  )))
Injury_poisoning <-  unique(stri_trans_totitle(c(.syn_c('poisoning'), .syn_c('dislocation',,T), .syn_c('lesion',,T), .syn_c('concussion',,T) )))
Morbidity_mortality_ext <- unique(stri_trans_totitle(c(.syn_c('morbid',,T), .syn_c('mortalit') )))
Circulatory_respiratory_sympt <-  unique(stri_trans_totitle(c(.syn_c('cough','exact'), .syn_c('breath',,T), .syn_c('sneezing'), .syn_c('snoring',,T) )))
Digestive_sympt<-  unique(stri_trans_totitle(c(.syn_c('faecal'), .syn_c('flatulence'), .syn_c('bowel'), .syn_c('colitis'),.syn_c('colic','exact'),.syn_c('pyrosis') )))
Skin_subcut_sympt<-  unique(stri_trans_totitle(c(.syn_c('oedema') )))
Nervous_musculoskeletal_sympt <- unique(stri_trans_totitle(c(.syn_c('tremor',,T), .syn_c('axtaxy'), .syn_c('spam'),.syn_c('ataxic',,T) )))
Cognitive_perc_emotional_sympt <- unique(stri_trans_totitle(c(.syn_c('somnolence'), .syn_c('stupor'), .syn_c('irritability'),.syn_c('hostil'),.syn_c('nervousness'),.syn_c('dizzin') )))
Medication_suppl <- unique(stri_trans_totitle(c(.syn_c('medication',,T), .syn_c('drug'), .syn_c('pharmacy'),.syn_c('medicament',,T),.syn_c('vaccination'),.syn_c('therapy') )))
Surgical_inter <- unique(stri_trans_totitle(c(.syn_c('surgical',,T), .syn_c('surgery'), .syn_c('ablation'),.syn_c('ectomy',,T),.syn_c('transplantation') )))                                                    
Radiological_inter <- unique(stri_trans_totitle(c(.syn_c('ultrasound'), .syn_c('radiation'), .syn_c('diogram') )))
Biosample_analyses <- unique(stri_trans_totitle(c(.syn_c('psa') )))
Other_non_pharmalogical_inter <- unique(stri_trans_totitle(c(.syn_c('physician',,T), .syn_c('radioscopy','exact'), .syn_c('dentist','exact') )))
Visit_health_prof <-  unique(stri_trans_totitle(c(.syn_c('dentist',,T), .syn_c('surgeon',,T), .syn_c('oncologist',,T),.syn_c('neurologist',,T), .syn_c('pneumologist',,T),.syn_c('respirologist',,T),.syn_c('nurse'),.syn_c('pediatrician',,T) )))
Hospitalizations <- unique(stri_trans_totitle(c(.syn_c('hospitalization',,T) )))
Community_care <- unique(stri_trans_totitle(c(.syn_c('care','exact') )))
Menst_menop_andropause <- unique(stri_trans_totitle(c(.syn_c('menopause',,T), .syn_c('menstr') )))
Contraception <- unique(stri_trans_totitle(c(.syn_c('contraception',,T), .syn_c('condom','exact',T) )))
Pregnancy_delivery <- unique(stri_trans_totitle(c(.syn_c('gestation',,T), .syn_c('caesarean',,T), .syn_c('birthing') )))
Gravidity_fertility <- unique(stri_trans_totitle(c(.syn_c('gravidity',,T), .syn_c('fertility') )))
Newborn_characteristics <-  unique(stri_trans_totitle(c(.syn_c('preemie',,T),.syn_c('newborn') )))
Child_school <-  unique(stri_trans_totitle(c(.syn_c('preschool'), .syn_c('nursery'), .syn_c('childhood','exact',T) )))
Life_status <-  unique(stri_trans_totitle(c(.syn_c('life','exact'), .syn_c('existence','exact'), .syn_c('death','exact') )))
Cause_death <-  unique(stri_trans_totitle(c(.syn_c('killing'), .syn_c('murder'), .syn_c('accident'),.syn_c('death') )))
Palliative_care <-  unique(stri_trans_totitle(c(.syn_c('allev',,T), .syn_c('palliati',,T) )))
Physical_characteristics <-  unique(stri_trans_totitle(c(.syn_c('dextrous',,T), .syn_c('hair','exact') )))
Circulation_respiration <-  unique(stri_trans_totitle(c(.syn_c('pulse','exact',T), .syn_c('respiration','exact',T), .syn_c('ecg','exact') )))
Muscle_skeleton_mobility <-  unique(stri_trans_totitle(c(.syn_c('muscle',,T), .syn_c('skeleton',,T), .syn_c('bone','exact') )))
Sensory_pain <-  unique(stri_trans_totitle(c(.syn_c('auditory'), .syn_c('sensory',,T), .syn_c('vision','exact'),.syn_c('macular'),.syn_c('pain','exact') )))
Brain_nerves <-  unique(stri_trans_totitle(c(.syn_c('brain',,T), .syn_c('nerve',,T) )))
Digesion <-  unique(stri_trans_totitle(c(.syn_c('digestion'),.syn_c('stomach','exact',T),.syn_c('gut','exact') )))
Psychological_emotional_distress <- unique(stri_trans_totitle(c(.syn_c('emotional'),.syn_c('seriousness',,T),.syn_c('behav') )))
Personality <- unique(stri_trans_totitle(c(.syn_c('personality','exact',T),.syn_c('assertive',,T),.syn_c('openness',,T),.syn_c('temper',,T),.syn_c('belief',,T),.syn_c('timidity','exact',T) )))
Hematology <- unique(stri_trans_totitle(c(.syn_c('thrombocyte','exact',T),.syn_c('hemoglobin','exact',T),.syn_c('fibrinogen','exact',T),.syn_c('ecf','exact',T),.syn_c('erythrocyte',,T),.syn_c('neutrophil',,T),.syn_c('serum',,T) )))
Biochemistry <- unique(stri_trans_totitle(c(.syn_c('glyceride',,T),.syn_c('triglycerid',,T),.syn_c('bicarbonate',,T),.syn_c('albumin',,T),.syn_c('protein'),.syn_c('lipid'),.syn_c('vitamin'),.syn_c('hormone'),.syn_c('enzyme',,T) )))
Microbiology <- unique(stri_trans_totitle(c(.syn_c('bacteria'),.syn_c('myco'),.syn_c('fungal'),.syn_c('microbe',,T) )))
Virology <- unique(stri_trans_totitle(c(.syn_c('virus',,T),.syn_c('viral',,T))))
Immunology <- unique(stri_trans_totitle(c(.syn_c('immunol'),.syn_c('immun'),.syn_c('cdd4',,T), .syn_c('immunoglobulin',,T) )))
Toxicology <-  unique(stri_trans_totitle(c(.syn_c('lead poisoning'),.syn_c('toxico'),.syn_c('poisoning'),.syn_c('intoxication') )))
Genomics <-  unique(stri_trans_totitle(c(.syn_c('ribonucleic',,T),.syn_c('genomic',,T),.syn_c('cloning'), .syn_c('genome'),.syn_c('genotype'),.syn_c('recombinant'),.syn_c('biotechnology') )))
Histology <- unique(stri_trans_totitle(c(.syn_c('biopsy'),.syn_c('histolog',,T),.syn_c('smear test',,T) )))
Soc_network <- unique(stri_trans_totitle(c(.syn_c('relationship',,T),.syn_c('interchange'),.syn_c('sharing',,T),.syn_c('segregation','exact',T),.syn_c('closeness',,T) )))
Life_events <- unique(stri_trans_totitle(c(.syn_c('prison','exact'),.syn_c('assault',,T),.syn_c('accident'),.syn_c('fortunate'),.syn_c('luck','exact') )))
Housing <- unique(stri_trans_totitle(c(.syn_c('housing','exact',T),.syn_c('apartment',,T),.syn_c('elevator','exact',T),.syn_c('condo','exact',T),.syn_c('heating','exact',T), .syn_c('landline',,T),
                                       .syn_c('electricity','exact',T),.syn_c('toilet facility'),.syn_c('terrace'),.syn_c('bedroom','exact'),.syn_c('stove',,T))))
Neighborhood <- unique(stri_trans_totitle(c(.syn_c('neighborhood'),.syn_c('mall','exact',T),.syn_c('environment','exact',T) )))
Radiation_exp <- unique(stri_trans_totitle(c(.syn_c('radiation'),.syn_c('scanner') )))
Chemical_exp <- unique(stri_trans_totitle(c(.syn_c('pesticide',,T),.syn_c('dissolvent'),.syn_c('perfume'),.syn_c('aroma','exact'),.syn_c('gasoline'),.syn_c('combustible','exact',T),.syn_c('aerosol',,T) )))
Biological_exp <- unique(stri_trans_totitle(c(.syn_c('bug','exact') )))
Identifiers <- unique(stri_trans_totitle(c(.syn_c('interviewer',,T),.syn_c('assessor',,T),.syn_c('observer','exact',T),.syn_c('informant','exact'),.syn_c('id','exact',T),.syn_c('questioner','exact',T) )))
Physical_measure_biosamp_related_info <- unique(stri_trans_totitle(c(.syn_c('measurement',,T),.syn_c('sample','exact'),.syn_c('specimen','exact',T) )))
Other_admin_info <- unique(stri_trans_totitle(c(.syn_c('followup','exact',T),.syn_c('consent',,T) )))

KW <- .cbind.na(Mental_behav_dis,Nervous_sys_dis,Eye_adnexa_dis,Ear_mastoid_dis,Circulatory_sys_dis,Respiratory_sys_dis,Digestive_sys_dis=NA,Skin_subcutaneous_dis,Musculoskeletal_sys_dis,
                Genitourinary_sys_dis = NA,Pregnancy_childbirth,Perinatal_cond,Cong_malform_chrom_abnor=NA,Cong_malform_chrom_abnor,Injury_poisoning,Morbidity_mortality_ext,Other_dis=NA,
                Circulatory_respiratory_sympt,Digestive_sympt,Skin_subcut_sympt,Nervous_musculoskeletal_sympt,Urinary_sympt=NA,Cognitive_perc_emotional_sympt,Speech_voice_sympt=NA,
                General_sympt=NA,Medication_suppl,Posology_protocol=NA,Other_pharmacological_inter=NA,Surgical_inter,Radiological_inter,Physical_inter=NA,Cognitive_psycho_sensory_inter=NA,
                Educational_inter=NA, Biosample_analyses,Other_non_pharmalogical_inter,Visit_health_prof,Hospitalizations,Community_care,Other_health_and_community_care=NA,
                Menst_menop_andropause,Contraception,Pregnancy_delivery,Breastfeeding=NA,Reprod_sexual_problems=NA,Other_reproductive=NA,Newborn_characteristics,Newborn_nutrition=NA,
                Newborn_development=NA,Newborn_daycare=NA,Child_school,Other_child_info=NA,Life_status,Cause_death,Palliative_care,Other_death=NA,Physical_characteristics,Anthropo_measures=NA,
                Circulation_respiration,Muscle_skeleton_mobility,Sensory_pain,Brain_nerves,Skin_subcutaneous=NA,Speech_voice=NA,Digesion,Reproduction=NA,Other_phys_measures=NA,
                Cognitive_functioning=NA,Psychological_emotional_distress,Personality,Other_psycholog_measures=NA,Hematology,Biochemistry,Microbiology,Virology,Immunology,Toxicology,
                Genomics,Histology,Other_lab_measures=NA,Histology,Soc_network,Soc_participation=NA,Soc_support=NA,Life_events,Housing,Neighborhood,Workplace=NA,Chemical_exp,
                Biological_exp,Other_environment=NA,Identifiers,Date_time_related_info=NA,Questionnaire_interview_related_info=NA,Data_sample_center=NA,Other_admin_info
              )
                                                  
                                                    
                                                    
                                                    