create user cloud_acctg_dev identified by info33gum;

grant connect,resource to cloud_acctg_dev;

alter user cloud_acctg_dev
   quota unlimited on users;

alter user cloud_acctg_dev
   account unlock;