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
package com.adeuza.movalysfwk.mf4mdd.ionic2.extractor;

import org.dom4j.Element;

import com.a2a.adjava.uml.UmlModel;
import com.a2a.adjava.uml2xmodele.extractors.AbstractExtractor;
import com.a2a.adjava.xmodele.MAction;
import com.a2a.adjava.xmodele.MActionType;
import com.a2a.adjava.xmodele.MPage;
import com.a2a.adjava.xmodele.MScreen;
import com.a2a.adjava.xmodele.ui.viewmodel.ViewModelType;
import com.adeuza.movalysfwk.mf4mdd.ionic2.xmodele.MF4HDictionary;
import com.adeuza.movalysfwk.mf4mdd.ionic2.xmodele.MF4HDomain;
import com.adeuza.movalysfwk.mf4mdd.ionic2.xmodele.MF4HModelFactory;

public class MF4HWorkspaceActionExtractor extends AbstractExtractor<MF4HDomain<MF4HDictionary,MF4HModelFactory>> {

	@Override
	public void initialize(Element p_xConfig) throws Exception {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void extract(UmlModel p_oModele) throws Exception {
		
		for (MScreen oScreen : getDomain().getDictionnary().getAllScreens()) {
			if (oScreen.isWorkspace()) {
				this.createActionsForWorkspaceScreen(p_oModele, oScreen);
			}
		}
		
	}

	private void createActionsForWorkspaceScreen(UmlModel p_oModele,
			MScreen p_oScreen) {
		
		// get first detail page with action
		MPage oPage = getFirstSaveDetail(p_oScreen);
		
		if (oPage != null) {
			MAction r_oSaveDetailAction = oPage.getActionOfType(MActionType.SAVEDETAIL);
			MAction r_oSaveAction = getDomain().getXModeleFactory().createAction("Save"+p_oScreen.getName()+"Action", r_oSaveDetailAction.getMasterInterface(), true, r_oSaveDetailAction.getPackage(), p_oScreen.getViewModel(), r_oSaveDetailAction.getDao(), r_oSaveDetailAction.getExternalDaos(), r_oSaveDetailAction.getCreatorName());
			r_oSaveAction.addParameter("WorkspaceLoaderName", p_oScreen.getName()+"DetailDataLoader");
			
			getDomain().getDictionnary().registerAction(r_oSaveAction);
		}
		
	}

	private MPage getFirstSaveDetail(MScreen p_oScreen) {
		MPage r_oPage = null;
		for (MPage oPage : p_oScreen.getPages()) {
			if (oPage.getViewModelImpl().getType().equals(ViewModelType.MASTER) || 
					oPage.getViewModelImpl().getType().equals(ViewModelType.DEFAULT)) {
				if (oPage.getActionOfType(MActionType.SAVEDETAIL) != null) {
					r_oPage = oPage;
					break;
				}
			}
		}
		return r_oPage;
	}

}
