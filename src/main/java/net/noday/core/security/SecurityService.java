/*
 * Copyright 2012 the original author or authors.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package net.noday.core.security;

import net.noday.core.model.User;
import net.noday.core.pagination.Page;
import net.noday.core.security.ShiroDbRealm.ShiroUser;
import net.noday.core.utils.Digests;

import org.apache.shiro.SecurityUtils;
import org.apache.shiro.util.ByteSource;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

/**
 * industrywords UserService
 *
 * @author <a href="http://www.noday.net">Noday</a>
 * @version , 2012-10-21
 * @since 
 */
@Service
public class SecurityService {

	@Autowired private SecurityDao dao;
	
	public void findPage(User condition, Page<User> pageData) {
		pageData.setCount(dao.findCount(condition));
		pageData.setRows(dao.findPage(condition, pageData.getIndex(), pageData.getSize()));
	}
	
	public void regist(User u) {
		entryptPassword(u);
		u.setRole("user");
		dao.save(u);
	}
	
	public User findUserByLoginName(String email) {
		User u = dao.findUserByLoginName(email);
		return u;
	}
	
	public User getUserByToken(String token) {
		User u = new User();
		return u;
	}
	
	public boolean checkLogin(User u) {
		
		return true;
	}
	
	/**
	 * 判断是否超级管理员.
	 */
	private boolean isSupervisor(Long id) {
		return id == 1;
	}

	/**
	 * 取出Shiro中的当前用户LoginName.
	 */
	private String getCurrentUserName() {
		ShiroUser user = (ShiroUser) SecurityUtils.getSubject().getPrincipal();
		return user.loginName;
	}

	/**
	 * 设定安全的密码，生成随机的salt并经过1024次 sha-1 hash
	 */
	private void entryptPassword(User user) {
		ByteSource salt = Digests.generateSalt(Digests.SALT_SIZE);
		user.setSalt(salt.toBase64());

		String hashPassword = Digests.sha256Hash(user.getPlainPassword(), salt, 1024);
		user.setPassword(hashPassword);
	}
}