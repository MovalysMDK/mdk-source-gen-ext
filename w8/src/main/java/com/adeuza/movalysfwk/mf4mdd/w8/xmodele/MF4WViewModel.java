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
package com.adeuza.movalysfwk.mf4mdd.w8.xmodele;

import java.util.ArrayList;
import java.util.List;

import org.apache.commons.lang3.StringUtils;
import org.dom4j.Element;

import com.a2a.adjava.xmodele.MEntityImpl;
import com.a2a.adjava.xmodele.MPackage;
import com.a2a.adjava.xmodele.ui.viewmodel.ViewModelType;
import com.a2a.adjava.xmodele.ui.viewmodel.mappings.IVMMappingDesc;
import com.adeuza.movalysfwk.mf4mdd.commons.xmodele.MFViewModel;

public class MF4WViewModel extends MFViewModel {

	private List<MF4WNavigation> navigations = new ArrayList<>();;

	public MF4WViewModel(String p_sName, String p_sUmlName,
			MPackage p_oPackage, ViewModelType p_sType,
			MEntityImpl p_oEntityToUpdate, String p_sPath,
			boolean p_bCustomizable, IVMMappingDesc p_oMapping) {
		super(p_sName, p_sUmlName, p_oPackage, p_sType, p_oEntityToUpdate, p_sPath,
				p_bCustomizable, p_oMapping);
	}

	public void addNavigation(MF4WNavigation navigation) {
		this.navigations.add(navigation);
	}

	public List<MF4WNavigation> getNavigations() {
		return this.navigations;
	}

	@Override
	public Element toXml() {
		Element r_xViewModel = super.toXml();
		
		Element xMapping = r_xViewModel.element("mapping");
		if ( xMapping != null ) {
			for( Element xElem : (List<Element>) xMapping.elements("entity")) {
				if ( "vmlist".equals(xElem.attributeValue("mapping-type"))) {
					Element xGetter = xElem.element("getter");
					String sMethodName = StringUtils.join(StringUtils.capitalize(xGetter.attributeValue("name")),".Add");
					xGetter.addAttribute("add-method", sMethodName);
				}
			}
		}

		Element xNavigations = r_xViewModel.addElement("navigations");
		for (MF4WNavigation oNavigation : this.navigations) {
			xNavigations.add(oNavigation.toXml());
		}

		return r_xViewModel;
	}
}
