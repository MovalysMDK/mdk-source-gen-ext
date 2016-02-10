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

import org.dom4j.Element;

import com.a2a.adjava.uml.UmlModel;
import com.a2a.adjava.uml2xmodele.extractors.AbstractExtractor;
import com.a2a.adjava.xmodele.IDomain;
import com.a2a.adjava.xmodele.IModelDictionary;
import com.a2a.adjava.xmodele.IModelFactory;
import com.a2a.adjava.xmodele.MAdapter;
import com.a2a.adjava.xmodele.MLayout;
import com.a2a.adjava.xmodele.MVisualField;
import com.a2a.adjava.xmodele.ui.component.MAbstractButton;
import com.a2a.adjava.xmodele.ui.view.MVFLabelKind;
import com.a2a.adjava.xmodele.ui.viewmodel.ViewModelType;

public class MF4WListNDExtractor extends AbstractExtractor<IDomain<IModelDictionary,IModelFactory>> {

	@Override
	public void initialize(Element p_xConfig) throws Exception {		
	}

	@Override
	public void extract(UmlModel p_oModele) throws Exception {
		for(MAdapter oMAdapter : this.getDomain().getDictionnary().getAllAdapters()){
			if(oMAdapter.getViewModel().getType() == ViewModelType.LIST_2 ){
				MLayout oListItem2Close = oMAdapter.getLayout("listitem2");
				MLayout oListItem2Open = oListItem2Close.cloneLayout();
				
				oListItem2Open.setName(oListItem2Close.getName() + "_open");
				oListItem2Open.setPage(oMAdapter.getViewModel().getPage());
				
				//création du visualfield de la list1d
				MVisualField oMVisualField = this.getDomain().getXModeleFactory().createVisualField("list1d", null, "MFList1D", MVFLabelKind.NO_LABEL, null, false);
				oListItem2Open.addVisualField(oMVisualField);
				
				
				//récupération du bouton de navigation vers le détails
				MAbstractButton tempButton = null;
				for(MAbstractButton navButton : oListItem2Close.getButtons()){
					if(navButton.getName().startsWith("button_create_")){
						tempButton = navButton;
						break;
					}
				}
				if(tempButton != null)
				{
					//le remove suffit car on a cloné le item close depuis le item open, il contient donc déjà le bouton
					oListItem2Close.getButtons().remove(tempButton);
				}
				
				oMAdapter.addLayout("listitem2_open", oListItem2Open);
				
				this.getDomain().getDictionnary().registerLayout(oListItem2Open);
			}
		}
	}
}
