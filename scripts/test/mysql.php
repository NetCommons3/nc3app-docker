<?php

error_reporting(-1);

$success = false;

for ($i = 1; $i <= 5; $i++) {
	try {
		echo 'PDO Connect';
		echo "\n";
		sleep(20);
		$db = new PDO(
			sprintf('%s:host=%s;port=%s', 'mysql', 'db_01', '3306'),
			'root',
			'root'
		);
		echo 'PDO Connect with db';
		$db = new PDO(
			sprintf('%s:dbname=%s;host=%s;port=%s', 'mysql', 'cakephp_test', 'db_01', '3306'),
			'root',
			'root'
		);
		$result = $db->query('SET NAMES utf8;');
		$success = true;
		break;
	} catch (Exception $ex) {
		echo 'code:' . $ex->getCode();
		echo "\n";
		echo 'message:' . $ex->getMessage();
		echo "\n";
		echo 'Retry connect ' . $i;
		echo "\n";
		continue;
	}
}

if ($success) {
	echo 'Success to MySQL connect.';
	echo "\n";
} else {
	echo 'Failure to MySQL connect.';
	echo "\n";
	exit(1);
}
