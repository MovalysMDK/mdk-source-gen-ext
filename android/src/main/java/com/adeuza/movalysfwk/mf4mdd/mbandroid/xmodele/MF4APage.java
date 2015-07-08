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

import com.a2a.adjava.uml.UmlClass;
import com.a2a.adjava.xmodele.MAction;
import com.a2a.adjava.xmodele.MPackage;
import com.a2a.adjava.xmodele.MPage;
import com.a2a.adjava.xmodele.MScreen;
import com.a2a.adjava.xmodele.MViewModelImpl;

public class MF4APage extends MPage {

	protected MF4APage(MScreen p_oScreen, String p_sType, String p_sPageName, UmlClass p_oUmlPage, MPackage p_oPackage, MViewModelImpl p_oVmImpl, boolean p_bTitled) {
		super(p_oScreen.isWorkspace()?p_oScreen:null, p_sType, p_sPageName, p_oUmlPage, p_oPackage, p_oVmImpl, p_bTitled);
	}

	public MF4APage(MScreen p_oParent, String p_sPageName, UmlClass p_oUmlPage, MPackage p_oPackage, MViewModelImpl p_oVmImpl, boolean p_bTitled) {
		super(p_oParent.isWorkspace()?p_oParent:null, p_sPageName, p_oUmlPage, p_oPackage, p_oVmImpl, p_bTitled);
	}
	
	@Override
	public void addAction(MAction p_oMAction) {
		for (MAction oAction:this.getActions()) {
			if (oAction.getName().equals(p_oMAction.getName())) {
				return;
			}
		}
		super.addAction(p_oMAction);
	}

	@Override
	protected void toXmlParentScreen(Element p_xElement) {
		if (getParent() != null) {
			super.toXmlParentScreen(p_xElement);
		} else {
			p_xElement.addElement("in-multi-panel").setText("true");
			p_xElement.addElement("in-workspace").setText("false");
		}
	}
	
}
