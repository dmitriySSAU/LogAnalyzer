function get_log_groups() {
    return dbEditor.get_log_groups()
}

function get_modify_log_groups(log_groups) {
    log_groups.unshift("Создать группу")
    return log_groups
}

function get_log_group_description(log_group_name) {
    return dbEditor.get_log_group_description(log_group_name)
}