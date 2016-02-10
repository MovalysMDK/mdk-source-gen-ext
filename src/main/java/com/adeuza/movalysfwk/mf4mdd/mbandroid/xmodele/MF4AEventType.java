/**
 * Copyright (C) 2010 Sopra Steria Group (movalys.support@soprasteria.com)
 *
 * This file is part of Movalys MDK.
 * Movalys MDK is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * Movalys MDK is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU Lesser General Public License for more details.
 * You should have received a copy of the GNU Lesser General Public License
 * along with Movalys MDK. If not, see <http://www.gnu.org/licenses/>.
 */
package com.adeuza.movalysfwk.mf4mdd.mbandroid.xmodele;

/**
 * <p>TODO Décrire la classe MEventType</p>
 *
 * <p>Copyright (c) 2012
 * <p>Company: Adeuza
 *
 * @author emalespine
 *
 */

public enum MF4AEventType {

	onadd("AddVALUEEvent"),
	onchange("ChangeVALUEEvent"),
	ondelete("DeleteVALUEEvent");

	String pattern;
	
	private MF4AEventType(String p_sPattern) {
		this.pattern = p_sPattern;
	}

	public String computeEventName(String p_sEntity) {
		return this.pattern.replace("VALUE", p_sEntity);
	}
}
