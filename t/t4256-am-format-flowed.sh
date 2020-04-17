#!/bin/sh

test_description='test format=flowed support of git am'

. ./test-lib.sh

test_expect_success 'setup' '
	cp "$TEST_DIRECTORY/t4256/1/mailinfo.c.orig" mailinfo.c &&
	cp "$TEST_DIRECTORY/t4256/2/vi.po.orig" vi.po &&
	git add mailinfo.c vi.po &&
	git commit -m initial
'

test_expect_success 'am with format=flowed' '
	git am <"$TEST_DIRECTORY/t4256/1/patch" 2>stderr &&
	test_i18ngrep "warning: Patch sent with format=flowed" stderr &&
	test_cmp "$TEST_DIRECTORY/t4256/1/mailinfo.c" mailinfo.c
'

test_expect_success 'am with format=flowed and mangled context space' '
	git am <"$TEST_DIRECTORY/t4256/2/patch" 2>stderr &&
	test_i18ngrep "warning: Patch sent with format=flowed" stderr &&
	test_cmp "$TEST_DIRECTORY/t4256/2/vi.po" vi.po
'

test_expect_failure 'am with format=flowed and mangled content space' '
	git am <"$TEST_DIRECTORY/t4256/2/patch-2" 2>stderr &&
	test_i18ngrep "warning: Patch sent with format=flowed" stderr &&
	test_cmp "$TEST_DIRECTORY/t4256/2/vi-2.po" vi.po
'

test_done
