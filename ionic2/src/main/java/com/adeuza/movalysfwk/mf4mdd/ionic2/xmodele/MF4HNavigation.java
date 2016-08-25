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
package com.adeuza.movalysfwk.mf4mdd.ionic2.xmodele;

import org.dom4j.Element;

import com.a2a.adjava.xmodele.MPage;
import com.a2a.adjava.xmodele.MScreen;
import com.a2a.adjava.xmodele.ui.navigation.MNavigation;
import com.a2a.adjava.xmodele.ui.navigation.MNavigationType;
import com.a2a.adjava.xmodele.ui.viewmodel.ViewModelType;

public class MF4HNavigation extends MNavigation {

	public MF4HNavigation(String p_sName, MNavigationType p_oNavigationType,
			MScreen source, MScreen target) {
		super(p_sName, p_oNavigationType, source, target);
	}

	@Override
	public Element toXml() {
		Element r_element = super.toXml();
		Element target = r_element.element("target");

		if (this.getTarget().isMultiPanel()) {
			target.addElement("isWorkspace").setText(String.valueOf(this.getTarget().isWorkspace()));

		}
		if(!this.getTarget().getPages().isEmpty()){
			Element sections = target.addElement("sections");
			for (MPage page : this.getTarget().getPages()) {
				Element section = sections.addElement("section");
				section.setText(page.getName());
				boolean list = false;
				if ( page.getViewModelImpl().getType().equals(ViewModelType.LIST_1) ||
						page.getViewModelImpl().getType().equals(ViewModelType.LIST_2) ||
						page.getViewModelImpl().getType().equals(ViewModelType.LIST_3) ) {
					list = true;
				}
				section.addAttribute("isList", String.valueOf(list) );
			}
		}

		
		return r_element;
	}
	
}
