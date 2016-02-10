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

import org.dom4j.Element;

import com.a2a.adjava.xmodele.MScreen;
import com.a2a.adjava.xmodele.ui.navigation.MNavigation;
import com.a2a.adjava.xmodele.ui.navigation.MNavigationType;

/**
 * @author lmichenaud
 *
 */
public class MF4ANavigation extends MNavigation {

	/**
	 * @param p_sName
	 * @param source
	 * @param target
	 */
	public MF4ANavigation(String p_sName, MNavigationType p_oNavigationType, MScreen source, MScreen target) {
		super(p_sName, p_oNavigationType, source, target);
	}

	/**
	 * (non-Javadoc)
	 * @see com.a2a.adjava.xmodele.ui.navigation.MNavigation#toXml()
	 */
	@Override
	public Element toXml() {
		Element r_xElement = super.toXml();
		MF4AScreen oScreen = (MF4AScreen) this.getTarget();
		r_xElement.element("target").addElement("request-code").setText(oScreen.getRequestCodeConstant());
		return r_xElement;
	}
}
