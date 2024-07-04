const serverLink = "https://alkhalil-mosque.com/api/";

// "http://127.0.0.1:8000/api/";
// "https://ibrahimalkhalil.000webhostapp.com/api/";

const apiPassword = "v6.3.5+28";

//auth
const logInLink = "${serverLink}login";

//person
const addPersonLink = "${serverLink}add_person";
const deletePersonLink = "${serverLink}delete_person";
const viewPersonLink = "${serverLink}view_person";
const viewAssistantsLink = "${serverLink}view_assistants";
const viewModeratorsLink = "${serverLink}view_moderators";
const viewSupervisorsLink = "${serverLink}view_supervisors";
const viewTestersLink = "${serverLink}view_testers";
const addPermissionLink = "${serverLink}appoint";
const appointStudentLink = "${serverLink}appoint_student";
const updatePersonLink = "${serverLink}update_person";
const editStudentLink = "${serverLink}edit_student";
const editPermissionLink = "${serverLink}edit_permission";
const viewAllPeopleLink = "${serverLink}view_all_people";
const viewTheAllPeopleLink = "${serverLink}ViewAllPeople";
const viewStudentsForTestersLink = "${serverLink}get_students_for_testers";

//images
const addImageLink = "${serverLink}add_image";
const imagesfolder = "${serverLink}storage/app/public/";

//group_links
const addGroupLink = "${serverLink}create_group";
const viewGroupsLink = "${serverLink}view_groups";
const deleteGroupLink = "${serverLink}delete_group";
const editGroupLink = "${serverLink}edit_group";
const viewGroupLink = "${serverLink}view_group";
const setDefaultGroupLink = "${serverLink}set_default_group";
const moveStudentsLink = "${serverLink}move_students";
const evaluateStudentsLink = "${serverLink}add_additional_points_list";
const setStudentsStateLink = "${serverLink}set_students_state";

//memoriation_links
const viewMemorizationLink = "${serverLink}view_memos"; //
const reciteLink = "${serverLink}recite"; //
const deleteReciteLink = "${serverLink}delete_reciting"; //
const editReciteLink = "${serverLink}edit_reciting";
const viewreciteLink = "${serverLink}view_recite";
const testLink = "${serverLink}test";
const editTestLink = "${serverLink}edit_test";
const deleteTestLink = "${serverLink}delete_test";
const testsInDateRangeLink = "${serverLink}tests_in_date_range";

//attendence_links
const attendenceLink = "${serverLink}attendance";
const viewAttendenceLink = "${serverLink}view_attendance";
const viewStudentAttendenceLink = "${serverLink}view_student_attendace";
const viewAllAttendenceLink = "${serverLink}view_all_attendances";

//additional_points_links
const viewAdditionalPointsLink = "${serverLink}view_additional_points";
const addAdditionalPointsLink = "${serverLink}add_additional_points";
const editAdditionalPointsLink = "${serverLink}edit_additional_points";
const deleteAdditionalPointsLink = "${serverLink}delete_additional_points";

//adminstrative_note_links
const addAdminstrativeNoteLinks = "${serverLink}add_adminstrative_note_list";
const editAdminstrativeNoteLinks = "${serverLink}edit_adminstrative_note";
const deleteAdminstrativeNoteLinks = "${serverLink}delete_adminstrative_note";
const viewAdminstrativeNoteLinks = "${serverLink}view_adminstrative_note";
const viewAllAdminstrativeNoteLink = "${serverLink}view_all_adminstrative_note";
