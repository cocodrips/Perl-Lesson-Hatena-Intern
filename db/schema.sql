CREATE TABLE user (
    `user_id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `name` VARBINARY(32) NOT NULL,
    `created` TIMESTAMP NOT NULL DEFAULT '0000-00-00 00:00:00',
    PRIMARY KEY (user_id),
    UNIQUE KEY (name),
    KEY (created)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE diary (
    `diary_id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `name` VARBINARY(512) NOT NULL,
    `user_id` BIGINT UNSIGNED NOT NULL,
    `created` TIMESTAMP NOT NULL DEFAULT '0000-00-00 00:00:00',
    `updated` TIMESTAMP NOT NULL DEFAULT '0000-00-00 00:00:00',
    PRIMARY KEY (diary_id),
    KEY (user_id),
    KEY (name),
    KEY (updated)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE entry (
    `entry_id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `user_id` BIGINT UNSIGNED NOT NULL,
    `diary_id` BIGINT UNSIGNED NOT NULL,
    `title` VARBINARY(512) NOT NULL,
    `body` VARBINARY(512) NOT NULL,
    `created` TIMESTAMP NOT NULL DEFAULT '0000-00-00 00:00:00',
    `updated` TIMESTAMP NOT NULL DEFAULT '0000-00-00 00:00:00',
    PRIMARY KEY (entry_id),
    KEY (user_id),
    KEY (diary_id),
    KEY (title),
    KEY (body),
    KEY (created)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE comment (
    `comment_id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `user_id` BIGINT UNSIGNED NOT NULL,
    `entry_id` BIGINT UNSIGNED NOT NULL,
    `comment` VARBINARY(512) NOT NULL,
    `created` TIMESTAMP NOT NULL DEFAULT '0000-00-00 00:00:00',
    `updated` TIMESTAMP NOT NULL DEFAULT '0000-00-00 00:00:00',
    PRIMARY KEY (comment_id),
    KEY (user_id),
    KEY (entry_id),
    KEY (comment),
    KEY (updated)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
