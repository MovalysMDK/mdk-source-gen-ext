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
package com.adeuza.movalysfwk.mf4mdd.w8.extractor;

import java.util.List;

import org.apache.commons.lang3.StringUtils;

import com.a2a.adjava.extractors.ExtractorParams;
import com.a2a.adjava.uml2xmodele.extractors.SearchDialogExtractor;
import com.a2a.adjava.uml2xmodele.ui.actions.ActionConstants;
import com.a2a.adjava.uml2xmodele.ui.actions.ActionFactory;
import com.a2a.adjava.uml2xmodele.ui.screens.ScreenContext;
import com.a2a.adjava.xmodele.IDomain;
import com.a2a.adjava.xmodele.IModelDictionary;
import com.a2a.adjava.xmodele.IModelFactory;
import com.a2a.adjava.xmodele.MAction;
import com.a2a.adjava.xmodele.MActionType;
import com.a2a.adjava.xmodele.MDialog;
import com.a2a.adjava.xmodele.MLayout;
import com.a2a.adjava.xmodele.MPackage;
import com.a2a.adjava.xmodele.MPage;
import com.a2a.adjava.xmodele.MScreen;
import com.adeuza.movalysfwk.mf4mdd.w8.xmodele.MF4WPage;

/**
 * @author lmichenaud
 *
 */
public class MF4WSearchDialogExtractor extends SearchDialogExtractor {

	/**
	 * (non-Javadoc)
	 * @see com.a2a.adjava.extractors.MExtractor#extract(com.a2a.adjava.uml.UmlModel)
	 */
//	@Override
//	public void extract(UmlModel p_oModele) throws Exception {
//		
//	}

	/**
	 * Complete layout of search dialog with cancel/ok buttons
	 * @param oSearchLayout layout to complete
	 * @param p_sBaseName base name for button
	 */
	protected void addValidationButtons(MLayout oSearchLayout, String p_sBaseName) {//		
	}

	/**
	 * @param p_oListScreen
	 */
	protected void addFilterButton(MDialog p_oDialog, MScreen p_oListScreen) {
	}
	
	public void completePageWithSearchInfo(MPage p_oPage, MLayout p_oLayout) {
		MF4WPage oMF4WPage = (MF4WPage) p_oPage;
		p_oLayout.setName(p_oLayout.getPage().get().getFullName());
		p_oLayout.setShortName(p_oLayout.getPage().get().getName());
		oMF4WPage.setSearchLayout(p_oLayout);
		
		// add save action and button
		StringBuilder oActionNameBuilder = new StringBuilder();
		oActionNameBuilder.append(ActionConstants.PREFIX_ACTION_SAVE).append(
				StringUtils.capitalize(p_oLayout.getPage().get().getName()));
		
		MAction oSaveDetailAction = ActionFactory.getInstance().addAction(this.getDomain(), false, p_oLayout.getPage().get(), null, 
				  oActionNameBuilder.toString(), p_oPage.getParent().getPackage(), 
				  MActionType.SAVEDETAIL, this.getDomain().getDictionnary().getViewModelCreator().getFullName());

		p_oLayout.getPage().get().addAction(oSaveDetailAction);
		p_oLayout.getPage().get().addImport(oSaveDetailAction.getMasterInterface().getFullName());
		p_oLayout.getPage().get().addImport(oSaveDetailAction.getMasterInterface().getOutClass());

	}

	/**
	 * @param p_oScreenUmlClass
	 * @return
	 */
//	public PanelAggregation getSearchPanelAggregation(UmlClass p_oScreenUmlClass) {
//		return null;
//	}
}
