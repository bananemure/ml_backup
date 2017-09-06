# | ----------- AREA INFORMATION HIERACHICAL STRUCTURE -------------------- | 

# AREA 
MLSTRM_AREA <- c(
                'Administrative_information', 
                'Cognitive_psychological_measures', 
                'Diseases', 
                'End_of_life', 
                'Health_community_care_utilization', 
                'Health_status_functional_limitations', 
                'Infancy_childhood', 
                'Laboratory_measures', 
                'Lifestyle_behaviours', 
                'Medication_supplements', 
                'Non_pharmacological_interventions', 
                'Physical_environment', 
                'Physical_measures', 
                'Reproduction', 
                'Social_environment', 
                'Sociodemographic_economic_characteristics', 
                'Symptoms_signs'
              )

#ID OF AREA
AREA_ID <- order(MLSTRM_AREA)

#AREA WITH ASSOCIATED TAGS
TAG_BY_AREA <-list(
  
  Administrative_information = c(
    'Data_sample_center','Date_time_related_info','Identifiers','Other_admin_info',
    'Physical_measure_biosamp_related_info','Questionnaire_interview_related_info'
    ),
  
  Cognitive_psychological_measures = c(
    'Cognitive_functioning','Other_psycholog_measures','Personality','Psychological_emotional_distress'
  ),
  
  Diseases = c(
    'Blood_immune_dis','Circulatory_sys_dis','Cong_malform_chrom_abnor','Digestive_sys_dis',
    'Ear_mastoid_dis','Endocrine_metabolic_dis','Eye_adnexa_dis','Genitourinary_sys_dis',
    'Infectious_dis','Injury_poisoning','Mental_behav_dis','Morbidity_mortality_ext',
    'Musculoskeletal_sys_dis','Neoplasms','Nervous_sys_dis','Other_dis','Perinatal_cond',
    'Pregnancy_childbirth','Respiratory_sys_dis','Skin_subcutaneous_dis'
    ), 
  
  End_of_life = c(
    'Cause_death','Life_status','Other_death','Palliative_care'
    ),
  
  Health_community_care_utilization = c(
    'Community_care','Hospitalizations','Other_health_and_community_care','Visit_health_prof'
    ),
  
  Health_status_functional_limitations = c(
    'Act_daily_living','Other','Perc_health','Qual_life','Use_devices'
    ),
  
  Infancy_childhood = c(
    'Child_school','Newborn_characteristics','Newborn_daycare','Newborn_development',
    'Newborn_nutrition','Other_child_info'
    ),
  
  Laboratory_measures = c(
    'Biochemistry','Genomics','Hematology','Histology','Immunology','Microbiology',
    'Other_lab_measures','Toxicology','Virology'
    ),
  
  Lifestyle_behaviours = c(
    'Alcohol','Drugs','Leisure_act','Nutrition','Other_lifestyle','Pers_hygiene',
    'Phys_act','Sex_behav','Sleep','Tobacco','Transportation'
    ),
  
  Medication_supplements = c(
    'Medication_suppl','Other_pharmacological_inter','Posology_protocol'
    ),
  
  Non_pharmacological_interventions = c(
    'Biosample_analyses','Cognitive_psycho_sensory_inter','Educational_inter',
    'Other_non_pharmacological_inter','Physical_inter','Radiological_inter','Surgical_inter'
    ),
  
  Physical_environment = c(
    'Biological_exp','Chemical_exp','Housing','Neighborhood','Other_environment',
    'Radiation_exp','Workplace'
    ),
  
  Physical_measures = c(
    'Anthropo_measures','Brain_nerves','Circulation_respiration','Digestion','Muscles_skeleton_mobility',
    'Other_phys_measures','Physical_characteristics','Reproduction','Sensory_pain','Skin_subcutaneous','Speech_voice'
    ),
  
  Reproduction =c(
    'Breastfeeding','Contraception','Gravidity_fertility','Menstr_menop_andropause',
    'Other_reproductive','Pregnancy_delivery','Reprod_sexual_problems'
    ),
  
  Social_environment = c(
    'Life_events','Other_soc_characteristics','Soc_network','Soc_participation','Soc_support'
    ),
  
  Sociodemographic_economic_characteristics = c(
    'Age','Birth_place','Citizenship','Education','Ethnic_race_religion',
    'Family_hh_struct','Income','Labour_retirement','Language','Marital_status',
    'Other_sociodemogr_chars','Residence','Sex','Twin'
    ),
  
  Symptoms_signs = c(
    'Circulatory_respiratory_sympt','Cognitive_perc_emotional_sympt','Digestive_sympt',
    'General_sympt','Nervous_musculoskeletal_sympt','Other_sympt','Skin_subcut_sympt',
    'Speech_voice_sympt','Urinary_sympt'
    )
  
)