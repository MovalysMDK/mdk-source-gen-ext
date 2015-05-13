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
package com.adeuza.movalysfwk.mf4mdd.html5.xmodele;

import java.util.List;

import org.dom4j.Element;

import com.a2a.adjava.xmodele.MEntityImpl;
import com.a2a.adjava.xmodele.MPackage;
import com.a2a.adjava.xmodele.ui.viewmodel.ViewModelType;
import com.a2a.adjava.xmodele.ui.viewmodel.mappings.IVMMappingDesc;
import com.adeuza.movalysfwk.mf4mdd.commons.xmodele.MFViewModel;

public class MF4HViewModel extends MFViewModel {

	public MF4HViewModel(String p_sName, String p_sUmlName,
			MPackage p_oPackage, ViewModelType p_sType,
			MEntityImpl p_oEntityToUpdate, String p_sPath,
			boolean p_bCustomizable, IVMMappingDesc p_oMapping) {
		super(p_sName, p_sUmlName, p_oPackage, p_sType, p_oEntityToUpdate, p_sPath,
				p_bCustomizable, p_oMapping);
	}
	
	@Override
	public Element toXml() {
		Element r_xVm = super.toXml();
		r_xVm.addElement("factory-name").setText(this.getName() + "Factory");
		
		for( Element xEntity : (List<Element>) r_xVm.element("mapping").elements("entity")) {
			String vmType = xEntity.attributeValue("vm-type");
			xEntity.addAttribute("vm-type-factory", vmType + "Factory");
		}
		
		// For listitem2 and listitem3, change the property name of the sub list to "list"
		if ( this.getType().equals(ViewModelType.LISTITEM_2) || this.getType().equals(ViewModelType.LISTITEM_3)) {
			Element xMapping = r_xVm.element("mapping");
			for( Element xEntity : (List<Element>) xMapping.elements("entity")) {
				if  ("vmlist".equals(xEntity.attributeValue("mapping-type"))) {
					xEntity.addAttribute("vm-attr", "list");
					break;
				}
			}
		}
		
		return r_xVm;
	}
}
