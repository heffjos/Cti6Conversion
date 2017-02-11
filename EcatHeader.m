
Offsets = [
    0
    1 * 20 % char            original_file_name[20]; 1
    2 % Int16           sw_version; 2
    2 % Int16           data_type; 3
    2 % Int16           system_type; 4
    2 % Int16           file_type; 5
    1 * 10 % char            node_id[10]; 6
    2 % Int16           scan_start_day, 7
    2 %                 scan_start_month, 8
    2 %                 scan_start_year, 9
    2 %                 scan_start_hour, 10
    2 %                 scan_start_minute, 11
    2 %                 scan_start_second; 12
    1 * 8 % char            isotope_code[8]; 13
    4 % float           isotope_halflife; 14
    1 * 32 % char            radiopharmaceutical[32]; 15
    4 % float           gantry_tilt, 16
    4 %                 gantry_rotation, 17
    4 %                 bed_elevation; 18
    2 % Int16           rot_source_speed, 19
    2 %                 wobble_speed, 20
    2 %                 transm_source_type; 21
    4 % float           axial_fov, 22
    4 %                 transaxial_fov; 23
    2 % Int16           transaxial_samp_mode, 24
    2 %                 coin_samp_mode, 25
    2 %                 axial_samp_mode; 26
    4 % float           calibration_factor; 27
    2 % Int16           calibration_units, 28
    2 %                 compression_code; 29
    1 * 12 % char            study_name[12], 30
    1 * 16 %                 patient_id[16], 31
    1 * 32 %                 patient_name[32], 32
    1 %                 patient_sex, 33
    1 * 10 %                 patient_age[10], 34
    1 * 10 %                 patient_height[10], 35
    1 * 10 %                 patient_weight[10], 36
    1 %                 patient_dexterity, 37
    1 * 32 %                 physician_name[32], 38
    1 * 32 %                 operator_name[32], 39
    1 * 32 %                 study_description[32]; 40
    2 % Int16           acquisition_type, 41
    2 %                 bed_type, 42
    2 %                 septa_type; 43
    1 * 20 % char            facility_name[20]; 44
    2 % Int16           num_planes, 45
    2 %                 num_frames, 46
    2 %                 num_gates, 47
    2 %                 num_bed_pos; 48
    4 % float           init_bed_position, 49
    4 * 15 %                 bed_offset[15], 50
    4 %                 plane_separation; 51
    2 % Int16           lwr_sctr_thres, 52
    2 %                 lwr_true_thres, 53
    2 %                 upr_true_thres; 54
    4 % float           collimator; 55
    1 * 10 % char            user_process_code[10]; 56
    2 % Int16           acquisition_mode; 57
 ];

locs = cumsum(Offsets) + 28; 
